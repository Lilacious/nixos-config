{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
  hm = inputs.home-manager.nixosModules.home-manager;
in {
  flake.nixosConfigurations = {
    orupi = lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = "x86_64-linux";
      };
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        ./modules
        ../../modules

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
