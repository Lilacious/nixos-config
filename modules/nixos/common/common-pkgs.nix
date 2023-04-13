{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # network
    wget
    curl

    # system
    pciutils
    usbutils
    dmidecode
    lm_sensors
    htop
    powertop

    # files
    zip
    unzip

    # clipboard
    wl-clipboard
    xclip
  ];
}

