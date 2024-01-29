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

  myModules = {
    ## Enable desktop environment
    desktop = {
      enable = true;
      plasma5.enable = true;
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
      firefoxDevedition.enable = false;
    };
  };

  ## Enable networking
  networking.networkmanager.enable = true;

  ## Bluetooth
  hardware.bluetooth.enable = true;

  services.samba-wsdd = {
  # make shares visible for Windows clients
  enable = true;
  openFirewall = true;
};

## amd gpu fan control
programs.corectrl.enable = true;

## Samba share
services.samba = {
  enable = true;
  openFirewall = true;
  securityType = "user";
  extraConfig = ''
    server string = smbnix
    netbios name = smbnix
    hosts allow = 192.168.122.11 ## 192.168.0. 127.0.0.1 localhost
  '';
  shares = {
    data = {
      path = "/data";
      browseable = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "yunix";
    };
  };
};
}
