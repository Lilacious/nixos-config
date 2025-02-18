{
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

      extraEntries = ''
                menuentry 'MacOS' --class macosx {
        	        insmod chain
        	        insmod part_gpt
                  insmod fat
                  insmod search_fs_uuid
                  search --fs-uuid --no-floppy --set=root 4696-767D
        	        chainloader ($root)/efi/MacOS-opencore/oc/OpenCore.efi
                }
      '';
    };
  };
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
    };

    services = {
      printing.enable = true;
      syncthing.enable = true;
    };

    programs = {
      gaming.enable = true;
      virt-manager.enable = true;
    };
  };
}
