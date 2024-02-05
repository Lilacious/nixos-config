{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/user.nix
    ../../modules
  ];
  system.stateVersion = "23.11";

  networking.hostName = "orupi";

  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    timeout = 1;
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  hardware.deviceTree.name = "rockchip/rk3588-orangepi-5-plus.dtb";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;
}
