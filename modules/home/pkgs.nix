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
    #  thunderbird  
  ];
}

