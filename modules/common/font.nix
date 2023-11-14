{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      hack-font
      roboto
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
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
          "Noto Serif CJK JP"
          "Noto Serif CJK SC"
          "Noto Serif CJK TC"
          "Noto Serif CJK KR"
        ];
        emoji = [ 
          "Noto Color Emoji" 
        ];
        sansSerif = [ 
          "Roboto Regular"
          "DejaVu Sans"
          "Noto Sans CJK JP"
          "Noto Sans CJK SC"
          "Noto Sans CJK TC"
          "Noto Sans CJK KR"
        ];
        monospace = [ 
          "Hack" 
          "DejaVu Sans Mono" 
        ];
      };
    };
  };
}
