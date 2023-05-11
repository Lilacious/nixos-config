{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
      kate
      keepassxc
      jetbrains.idea-ultimate
      vscodium
      discord
      element-desktop
      texlive.combined.scheme-full
      hyprpicker
      networkmanagerapplet
      mumble
    #  thunderbird  
  ];
}

