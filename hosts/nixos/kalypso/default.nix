{ self, inputs, ... }:
let
  nixhw = inputs.nixos-hardware.nixosModules;
in
{
  flake.nixosConfigurations.kalypso = self.lib.mkNixos "kalypso" {
    profile = "workstation";
    modules = [
      nixhw.common-cpu-amd-pstate
      nixhw.common-gpu-nvidia-nonprime
      nixhw.common-pc-ssd
      ./hardware-configuration.nix
      ./configuration.nix
      ./modules

      #inputs.lix-module.nixosModules.default
    ];
  };
}
