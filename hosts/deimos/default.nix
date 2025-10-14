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
        self.nixosModules.nixos
        ../../users/yunix/headless.nix

        inputs.nixos-wsl.nixosModules.default
        {
          wsl = {
            enable = true;
            defaultUser = "yunix";
          };
          networking.hostName = "deimos";
          nixpkgs.hostPlatform = arch;
          system.stateVersion = "24.05";
        }
      ];
    };
  };
}
