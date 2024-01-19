{ pkgs, ... }:
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

  services.openssh.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;
}
