{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/user.nix
    ../../modules
  ];
  system.stateVersion = "23.11";

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

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelPackages = (import (builtins.fetchTarball https://gitlab.com/vriska/nix-rpi5/-/archive/main.tar.gz)).legacyPackages.aarch64-linux.linuxPackages_rpi5;

  networking.networkmanager.enable = true;
}
