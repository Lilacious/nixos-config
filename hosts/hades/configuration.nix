{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../users/kailee/kailee.nix
  ];
  system.stateVersion = "22.05";

  networking.hostName = "hades";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.openssh = {
  enable = true;
    # require public key authentication for better security
    # passwordAuthentication = false;
    # kbdInteractiveAuthentication = false;
    # permitRootLogin = "yes";
  };


  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # mirrored 4 TB drives
  fileSystems."/mnt/data" = {
    device = "data";
    fsType = "zfs";
  };

  networking.hostId = "d93a8103";

  # security.polkit.enable = true;

  # hardware.enableRedistributableFirmware = true;
}
