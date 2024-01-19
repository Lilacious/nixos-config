{ linux-rpi5, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/user.nix
    ../../modules
  ];
  system.stateVersion = "23.05";

  networking.hostName = "arupi";

  ## Grub bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  boot.kernelPackages = linux-rpi5.linux_rpi5;

  networking.networkmanager.enable = true;
}
