{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/workstation.nix
    ../../users/kailee/kailee.nix
    ../sisyphos/packages.nix
    ../../modules/nixos/syncthing.nix
    #../../modules/nixos/printing.nix
    #../../modules/nixos/bluetooth.nix
    #../../modules/nixos/virtualization.nix
  ];
  system.stateVersion = "22.05";

  networking.hostName = "penelope";

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
