{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gparted
    neofetch

    wirelesstools

    ripgrep
    fd
    ncdu
    tree
  ];
}

