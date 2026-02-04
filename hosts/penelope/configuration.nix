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
      plasma.enable = true;

      services = {
        printing.enable = true;
      };
    };

    programs = {
      gaming.enable = true;
      virt-manager.enable = true;
      jetbrains.idea.enable = true;
      nintendo.switch.enable = true;
    };
  };
}
