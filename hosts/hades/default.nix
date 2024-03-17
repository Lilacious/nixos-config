{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
  hm = inputs.home-manager.nixosModules.home-manager;
in {
  flake.nixosConfigurations = {
    hades = lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = "x86_64-linux";
      };
      modules = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        ./hardware-configuration.nix
        ./configuration.nix
        ./modules
        ../../modules
        ../../secrets

        # Enable Yunix
        ../../users/yunix

        hm
        {
          home-manager = {
            extraSpecialArgs = {};
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
      ];
    };
  };
}
