{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.other.fonts;
in
{
  options = with types; {
    myModules.other.fonts = {
      enable = mkEnableOption "default fonts";
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      # noto cjk fonts are part of enableDefaultPackages
      packages = with pkgs; [
        inter
        nerd-fonts.jetbrains-mono
        source-serif
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = [
            "Source Serif 4"
            "Noto Serif CJK JP"
            "Noto Serif CJK SC"
            "Noto Serif CJK TC"
            "Noto Serif CJK KR"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
          sansSerif = [
            "Inter"
            "Noto Sans CJK JP"
            "Noto Sans CJK SC"
            "Noto Sans CJK TC"
            "Noto Sans CJK KR"
          ];
          monospace = [
            "JetBrainsMono Nerd Font Mono"
            "Noto Sans Mono CJK JP"
            "Noto Sans Mono CJK SC"
            "Noto Sans Mono CJK TC"
            "Noto Sans Mono CJK KR"
          ];
        };
      };
    };
  };
}
