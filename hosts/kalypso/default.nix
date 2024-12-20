{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
  nixhw = inputs.nixos-hardware.nixosModules;
in
{
  flake.nixosConfigurations = {
    kalypso = lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = "x86_64-linux";
      };
      modules = [
        nixhw.common-cpu-amd-pstate
        nixhw.common-pc-ssd
        ./hardware-configuration.nix
        ./configuration.nix
        ./modules
        self.nixosModules.workstation

        inputs.lix-module.nixosModules.default
      ];
    };
  };
}
