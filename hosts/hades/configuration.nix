{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/user.nix
    ../../modules
    ../../secrets
    ./modules/dashboard.nix
    ./modules/torrent.nix
    ./modules/cloud.nix
  ];
  system.stateVersion = "23.05";

  boot.kernelPackages = pkgs.linuxPackages_6_5;

  security.doas.enable = false;

  networking.hostName = "hades";

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

  # Enable networking
  networking.networkmanager.enable = true;

  networking.interfaces.enp1s0.wakeOnLan.enable = true;

  services.openssh = {
  enable = true;
    settings = {
      # require public key authentication for better security
      # PasswordAuthentication = false;
      # KbdInteractiveAuthentication = false;
      # permitRootLogin = "yes";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
  };

  # zstd compression
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };
  swapDevices = [ { device = "/swap/swapfile"; } ];

  boot.zfs.extraPools = [ "data" ];

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
