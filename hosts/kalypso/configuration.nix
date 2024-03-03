{ pkgs, variables, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./vfio.nix
    ../../users/user.nix
    ../../modules
  ];
  system.stateVersion = "23.11";

  networking.hostName = "kalypso";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi"; 
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  ## Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ## Local modules
  myModules = {
    ## Enable desktop environment
    desktop = {
      enable = true;
      plasma.enable = true;
    };

    services = {
      ## Enable printing
      printing.enable = false;

      ## Enable virtualization
      virtualization.enable = true;

      syncthing.enable = true;
    };

    programs = {
      cysecTools.enable = false;
      tudTools.enable = true;
      firefoxDevedition.enable = false;
    };
  };

  ## Enable networking
  networking.networkmanager.enable = true;

  ## Enable SSH
  services.openssh = {
    enable = true;
    settings = {
      # require public key authentication for better security
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      #PermitRootLogin = "yes";
    };
  };

  ## Bluetooth
  hardware.bluetooth.enable = true;

  ## Enable OpenTabletDriver
  #hardware.opentabletdriver.enable = true;

  ## Enable Steam
  programs.steam = {
    enable = true;
  };
  
  ## AMD GPU fan control
  programs.corectrl.enable = true;
  users.users.${variables.username}.extraGroups = [ "corectrl" ];
}
