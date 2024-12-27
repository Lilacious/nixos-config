{
  system.stateVersion = "24.11";
  networking.hostName = "aergia";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  networking.networkmanager.enable = true;
}
