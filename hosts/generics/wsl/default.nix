{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
  arch = "x86_64-linux";
in
{
  flake.nixosConfigurations = {
    wsl = lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = arch;
      };
      modules = [
        ./configuration.nix
        self.nixosModules.wsl

        inputs.nixos-wsl.nixosModules.default
        {
          networking.hostName = "wsl";
          nixpkgs.hostPlatform = arch;
          system.stateVersion = "24.05";
        }
      ];
    };
  };
}
