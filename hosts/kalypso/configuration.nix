{
  pkgs,
  config,
  ...
}:
{
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

      theme = pkgs.catppuccin-grub.override { flavor = "mocha"; };
      # Lags on Nvidia GPU workaround
      gfxmodeEfi = "1920x1080x32,auto";
    };
  };

  ## Use proprietary NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;
    modesetting.enable = true;
  };

  ## Enable networking
  networking.networkmanager.enable = true;

  ## Enable SSH
  services.openssh = {
    enable = false;
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

  ## Local modules
  myModules = {
    ## Enable desktop environment
    desktop = {
      gnome.enable = false;
      plasma.enable = true;
    };

    services = {
      ## Enable printing
      printing.enable = true;
      ## Enable syncthing
      syncthing.enable = true;
    };

    other = {
      dualboot.enable = true;
    };

    programs = {
      gaming.enable = true;
      virt-manager = {
        enable = true;
        enableOSX = true;
      };
    };
  };
}
