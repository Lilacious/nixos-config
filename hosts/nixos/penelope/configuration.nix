{
  system.stateVersion = "22.05";
  networking.hostName = "penelope";

  ## Grub bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };
  ## Update firmware
  #services.fwupd.enable = true;

  ## Power/Battery
  powerManagement.powertop.enable = true;
  ## Enable networking
  networking.networkmanager.enable = true;
  # Fix wg-quick issues
  services.resolved.enable = true;

  ## Bluetooth
  hardware.bluetooth.enable = true;

  myModules = {
    desktop = {
      gnome.enable = false;
      plasma.enable = false;
      niri.enable = true;
      hyprland = {
        enable = true;
        # 1536x864 like niri picks it, which noctalia's lock screen layout is made for
        settings.monitor = [
          {
            output = "eDP-1";
            mode = "preferred";
            position = "auto";
            scale = 1.25;
          }
          {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = "auto";
          }
        ];
      };

      services = {
        printing.enable = true;
      };
    };

    programs = {
      gaming.enable = true;
      virt-manager.enable = true;
      jetbrains.idea.enable = false;
      nintendo.switch.enable = true;
    };
  };
}
