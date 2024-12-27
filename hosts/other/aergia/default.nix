{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  flake.nixosConfigurations = {
    aergia = lib.nixosSystem {
      specialArgs = {
        inherit self inputs;
        system = "x86_64-linux";
      };
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        self.nixosModules.desktop
      ];
    };
  };
}
