{
  inputs,
  lib,
  ...
}:
with lib;
{
  imports = [
    ../modules/core

    inputs.nixvim.nixosModules.nixvim
    ../modules/vim

    inputs.stylix.nixosModules.stylix
    ../modules/stylix
  ];

  networking.firewall.enable = mkForce true;
}
