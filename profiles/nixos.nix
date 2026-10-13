{
  lib,
  ...
}:
with lib;
{
  imports = [
    (import ./base.nix "nixos")
  ];

  networking.firewall.enable = mkForce true;
}
