{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gparted
    neofetch

    ripgrep
    fd
    ncdu
    tree
  ];
}

