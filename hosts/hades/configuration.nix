{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../users/kailee/kailee.nix
  ];
  system.stateVersion = "23.05";

  networking.hostName = "hades";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.openssh = {
  enable = true;
    settings = {
      # require public key authentication for better security
      # PasswordAuthentication = false;
      # KbdInteractiveAuthentication = false;
      # permitRootLogin = "yes";
    };
  };

  # zstd compression
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };
  swapDevices = [ { device = "/swap/swapfile"; } ];


  services.zfs.autoScrub.enable = true;

  services.zfs.trim.enable = true;
  
  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs.forceImportRoot = false;

  networking.hostId = "d93a8103";

  # disk spin-down
  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -S 180 /dev/disk/by-id/ata-ST4000DM004-2CV104_WFN86XH3
    ${pkgs.hdparm}/sbin/hdparm -S 180 /dev/disk/by-id/ata-ST4000DM004-2CV104_WFN86XLT
  '';

  powerManagement = {
    # powertop autotune
    powertop.enable = true;
    # SATA Active Link Power Management
    scsiLinkPolicy = "med_power_with_dipm";
  };

  # security.polkit.enable = true;

  # hardware.enableRedistributableFirmware = true;
}
