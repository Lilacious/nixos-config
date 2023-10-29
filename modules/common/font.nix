{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      hack-font
      roboto
      (nerdfonts.override { 
        fonts = [ 
          "FiraCode" 
          "Agave" 
        ]; 
      })
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ 
          "Agave Nerd Font" 
          "Fira Code" 
          "DejaVu Serif" 
        ];
        emoji = [ 
          "Noto Color Emoji" 
        ];
        sansSerif = [ 
          "Roboto Regular" 
          "DejaVu Sans" 
        ];
        monospace = [ 
          "Hack" 
          "DejaVu Sans Mono" 
        ];
      };
    };
  };
}
