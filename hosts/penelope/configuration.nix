{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    ./hardware-configuration.nix
    ../../users/user.nix
    ../../modules/nixos/agenix.nix
    ../../modules/nixos/hyprland.nix
    ../sisyphos/packages.nix
    ../../profiles/workstation.nix
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
