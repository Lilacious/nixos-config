{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## Web browser
    firefox

    ## Password manager
    keepassxc

    ## Network
    networkmanagerapplet

    ## Other
    gparted # parted with ui
  ];
}
