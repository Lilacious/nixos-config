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

    ## Other
    neofetch    # Sys info fetcher
    tree        # Indented directory listing
    ncdu        # Disk usage analyzer
    ripgrep
    fd          # Simple find command
    python3
    cheat       # cheat sheet
  ];
}
