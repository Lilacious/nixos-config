{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## Password manager
    keepassxc

    ## IDE
    jetbrains.idea-ultimate

    ## Communication
    mumble
    discord
    element-desktop
    
    ## Network
    networkmanagerapplet

    ## Other
    # edid-decode # decode display edid to readable info
    gparted # parted with ui
    # wireguard-tools
    # texlive.combined.scheme-basic
    # texlive.combined.scheme-full
    # thunderbird    
    xournalpp
    spotify
    kitty

    ## Development
    (python3.withPackages(ps: with ps; [ tkinter ]))
    # gcc
  ];
}
