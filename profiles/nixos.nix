{
  inputs,
  lib,
  ...
}:
with lib;
{
  imports = [
    ../modules/core
    ../modules/core/vim
    inputs.nixvim.nixosModules.nixvim
  ];

  networking.firewall.enable = mkForce true;

  boot = {
    # Grub in text mode
    loader.grub.splashImage = null;
  };
}
