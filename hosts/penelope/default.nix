{ inputs, ... }:
let 
  lib = inputs.nixpkgs.lib;
  hm = inputs.home-manager.nixosModules.home-manager;
in {
  flake.nixosConfigurations = {
    penelope = lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = "x86_64-linux";
      };
      modules = [
        ./configuration.nix
        hm {
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