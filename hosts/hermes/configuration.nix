{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/user.nix
    ../../profiles/common.nix
    ../modules/nixos/plasma5.nix
    ../modules/nixos/xorg.nix
    ../modules/nixos/pipewire.nix
    ../modules/nixos/fonts.nix
  ];
  system.stateVersion = "23.05";

  boot.loader = {
    efi.efiSysMountPoint = "/boot/efi";
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      enableCryptodisk = true;
    };
  };

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/TODO";
      preLVM = true;
    };
  };

  networking.hostName = "hermes";

  # Enable networking
  networking.networkmanager.enable = true;
  
  /*
  services.openssh = {
  enable = true;
  };*/

  security.polkit.enable = true;
  services.dbus.enable = true;

  hardware.enableRedistributableFirmware = true;
}
