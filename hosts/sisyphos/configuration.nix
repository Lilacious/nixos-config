{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/user.nix
    ./packages.nix
    ../../modules
  ];
  system.stateVersion = "23.11";

  networking.hostName = "sisyphos";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
  };
  
  environment.systemPackages = with pkgs; [
    steamPackages.steamcmd
  ];
}
