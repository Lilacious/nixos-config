{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## Password manager
    keepassxc

    ## IDE
    jetbrains.idea-ultimate
    vscodium

    ## Communication
    # mumble
    discord
    element-desktop

    ## Network
    networkmanagerapplet

    ## PDF viewer
    # zathura

    ## Flash card
    # anki

    ## Other
    # edid-decode # decode display edid to readable info
    # gparted # parted with ui
    # wireguard-tools
    # texlive.combined.scheme-basic
    # texlive.combined.scheme-full
    # thunderbird    
    ## Development
    # python3
    # gcc
  ];
}
