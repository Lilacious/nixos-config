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

  ## Local modules
  myModules = {
    ## Enable desktop environment
    desktop = {
      plasma.enable = true;
      hyprland.enable = true;
    };

    services = {
      ## Enable printing
      printing.enable = false;

      ## Real-time microphone noise suppression
      noisetorch.enable = true;

      ## AMD GPU fan control
      corectrl.enable = true;
    };

    programs = {
      cysecTools.enable = false;
      firefoxDevedition.enable = false;
      tudTools.enable = true;
      virt-manager.enable = true;
      vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          ms-python.python
        ];
      };
    };
  };
}
