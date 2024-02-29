{ inputs, variables, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    ./hardware-configuration.nix
    ./packages.nix
    ../../users/user.nix
    ../../modules
    ../../secrets   ## agenix
  ];
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
    };
  };

  myModules = {
    ## Enable desktop environment
    desktop = {
      enable = true;
      plasma.enable = true;
    };

    services = {
      ## Enable printing
      printing.enable = true;

      ## Enable virtualization
      virtualization.enable = true;

      syncthing.enable = true;
    };

    programs = {
      cysecTools.enable = true;
      firefoxDevedition.enable = true;
    };
  };

  ## Enable networking
  networking.networkmanager.enable = true;

  ## Bluetooth
  hardware.bluetooth.enable = true;

  # services.dbus.enable = true;

  ## Custom aliases for penelope
  home-manager.users.${variables.username} = {
    programs.zsh = {
      shellAliases = {
        open-front-door = "ssh door@bourbon.w17.io buzzer";
        open-sesame = "ssh door@bourbon.w17.io open";
        close-sesame = "ssh door@bourbon.w17.io close";
        battery-info-internal = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
        battery-info-external = "upower -i /org/freedesktop/UPower/devices/battery_BAT1";
      };
    };
  };
}
