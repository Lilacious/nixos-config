{ inputs, ... }:
let 
  lib = inputs.nixpkgs.lib;
in {
  flake.nixosConfigurations = {
    kalypso = lib.nixosSystem {
      specialArgs = {
        system = "x86_64-linux";
      };
      modules = [
        ./configuration.nix
      ];
    };
  };
}