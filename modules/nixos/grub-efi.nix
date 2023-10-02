{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi"; ## remove to mount efi partition to <root>/boot
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };
}

