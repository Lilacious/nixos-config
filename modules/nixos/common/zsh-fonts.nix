{ config, pkgs, ... }:
{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      hack-font
      fira-code
      roboto
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Fira Code" "DejaVu Serif" ];
        emoji = [ "Noto Color Emoji" ];
        sansSerif = [ "Roboto Regular" "DejaVu Sans" ];
        monospace = [ "Hack" "DejaVu Sans Mono" ];
      };
    };
  };

}

