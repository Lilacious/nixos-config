{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
  hm = inputs.home-manager.nixosModules.home-manager;
in {
  flake.nixosConfigurations = {
    kalypso = lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = "x86_64-linux";
      };
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        ./packages.nix
        ./vfio.nix
        ../../modules

        # Enable yunix
        ../../users/yunix

        hm
        {
          home-manager = {
            extraSpecialArgs = {
              inherit inputs;
            };
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
      ];
    };
  };
}
