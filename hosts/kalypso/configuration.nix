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
}
