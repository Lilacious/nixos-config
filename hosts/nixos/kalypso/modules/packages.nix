{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## IDE
    #jetbrains.idea-ultimate

    ## Network
    # networkmanagerapplet

    ## Other
    # edid-decode # decode display edid to readable info
    # gparted # parted with ui
    # wireguard-tools
    # texlive.combined.scheme-basic
    # texlive.combined.scheme-full

    ## Development
    # (python3.withPackages (ps: with ps; [ tkinter ]))
    # gcc
  ];
}
