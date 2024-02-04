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
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    grub.enable = false;
  };

  hardware = {
    deviceTree = {
      # https://github.com/armbian/build/blob/f9d7117/config/boards/orangepi5-plus.wip#L10C51-L10C51
      name = "rockchip/rk3588-orangepi-5-plus.dtb";
      overlays = [
      ];
    };
    firmware = [
    ];
  };

  services.openssh.enable = true;

  boot.kernelPackages = (pkgs.callPackage ../../pkgs/rk3588-linux/package.nix {});

  networking.networkmanager.enable = true;
}
