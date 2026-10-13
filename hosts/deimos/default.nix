{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
  arch = "x86_64-linux";
in
{
  flake.nixosConfigurations = {
    deimos = lib.nixosSystem {
      specialArgs = {
        inherit self inputs;
        system = arch;
      };
      modules = [
        ./configuration.nix
        self.nixosModules.wsl
        ../../users/yunix/headless.nix

        {
          wsl.defaultUser = "yunix";
          networking.hostName = "deimos";
          nixpkgs.hostPlatform = arch;
          system.stateVersion = "24.05";
        }
      ];
    };
  };
}
