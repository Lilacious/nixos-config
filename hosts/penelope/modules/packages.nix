{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## Flash card
    anki

    ## Other
    edid-decode # decode display edid to readable info
    # gparted # parted with ui
    wireguard-tools
    openconnect # VPN Client for Cisco's AnyConnect SSL VPN
    signal-desktop-bin # Signal messenger
  ];
}
