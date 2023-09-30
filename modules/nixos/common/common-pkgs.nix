{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## Network
    wget
    curl

    ## System
    pciutils
    usbutils
    dmidecode
    lm_sensors
    htop

    ## Files
    zip
    unzip

    ## Clipboard
    wl-clipboard
    xclip

    ## Other
    neofetch  # Sys info fetcher
    tree  # Indented directory listing
    ncdu  # Disk usage analyzer
    ripgrep
    fd  # Simple find command
    socat
    python3
    jq # JSON processor
  ];
}

