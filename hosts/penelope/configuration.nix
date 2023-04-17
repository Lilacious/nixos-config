{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/workstation.nix
    ../../users/kailee/kailee.nix
    ../sisyphos/packages.nix
  ];
  system.stateVersion = "22.05";

  networking.hostName = "penelope";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  /*
  services.openssh = {
  enable = true;
    settings = {
      # require public key authentication for better security
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
      # permitRootLogin = "yes";
    };
  };
  */

  security.polkit.enable = true;

  hardware.enableRedistributableFirmware = true;
}
