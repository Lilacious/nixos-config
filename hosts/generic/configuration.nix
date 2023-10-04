{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/user.nix
    ../../profiles/common.nix
    ../../modules/nixos/plasma5.nix
    ../../modules/nixos/xorg.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/grub-efi.nix
  ];
  system.stateVersion = "23.05";

  networking.hostName = "hermes";

  # Enable networking
  networking.networkmanager.enable = true;
  
  security.polkit.enable = true;
  services.dbus.enable = true;

  hardware.enableRedistributableFirmware = true;
}
