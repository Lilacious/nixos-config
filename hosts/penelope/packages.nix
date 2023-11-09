{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## Web browser
    firefox

    ## Password manager
    keepassxc

    ## IDE
    jetbrains.idea-ultimate
    vscodium

    ## Communication
    mumble
    discord
    element-desktop

    ## Network
    networkmanagerapplet

    ## Other
    edid-decode # decode display edid to readable info
    # gparted # parted with ui
    wireguard-tools
    # texlive.combined.scheme-basic
    texlive.combined.scheme-full
    # thunderbird    
    python3
  ];
}
