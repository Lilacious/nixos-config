{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## PDF viewer
    zathura

    ## Flash card
    anki

    ## Other
    edid-decode # decode display edid to readable info
    # gparted # parted with ui
    wireguard-tools
    openconnect # VPN Client for Cisco's AnyConnect SSL VPN
    signal-desktop # Signal messenger
  ];
}
