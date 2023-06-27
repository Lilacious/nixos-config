{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/workstation.nix
    ../../users/kailee/kailee.nix
    ../sisyphos/packages.nix
    ../../modules/nixos/syncthing.nix
    #../../modules/nixos/printing.nix
    ../../modules/nixos/bluetooth.nix
  ];
  system.stateVersion = "22.05";

  networking.hostName = "penelope";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  /*
  services.openssh = {
  enable = true;
  };*/

  security.polkit.enable = true;
  services.dbus.enable = true;

  # Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ 
    virt-manager
  ];

  hardware.enableRedistributableFirmware = true;
}
