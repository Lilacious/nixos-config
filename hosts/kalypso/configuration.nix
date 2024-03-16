{pkgs, ...}: {
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
      hyprland.enable = true;
    };

    services = {
      ## Enable printing
      printing.enable = false;

      ## Enable virtualization
      virtualization.enable = true;

      ## Enable syncthing
      syncthing.enable = true;

      ## Real-time microphone noise suppression
      noisetorch = {
        enable = true;
      };

      ## AMD GPU fan control
      corectrl.enable = true;
    };

    programs = {
      vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          ms-python.python
        ];
      };
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
}
