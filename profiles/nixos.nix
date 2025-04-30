{
  inputs,
  lib,
  ...
}:
with lib;
{
  imports = [
    ../modules/core
    ../modules/vim
    inputs.nixvim.nixosModules.nixvim
  ];

  networking.firewall.enable = mkForce true;
}
