{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## Flash card
    anki

    ## Other
    deploy-rs # deploy NixOS hosts, see nixos-config-private/hosts/deploy.nix
    edid-decode # decode display edid to readable info
    # gparted # parted with ui
    wireguard-tools
    openconnect # VPN Client for Cisco's AnyConnect SSL VPN
    signal-desktop # Signal messenger
  ];
}
