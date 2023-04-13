{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gparted
    neofetch

    exa
    ripgrep
    fd
    ncdu
  ];
}

