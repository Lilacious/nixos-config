{pkgs, ...}: {
  system.stateVersion = "22.05";
  networking.hostName = "penelope";

  ## Grub bootloader
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
  ## Enable networking
  networking.networkmanager.enable = true;

  ## Bluetooth
  hardware.bluetooth.enable = true;

  myModules = {
    desktop = {
      plasma.enable = true;
    };

    services = {
      printing.enable = true;
    };

    programs = {
      cysecTools.enable = true;
      firefoxDevedition.enable = true;
      tudTools.enable = true;
      virt-manager.enable = true;
      vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          james-yu.latex-workshop
        ];
      };
    };
  };
}
