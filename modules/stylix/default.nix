{ pkgs, ... }:
{
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = {
      base00 = "#232136";
      base01 = "#2a273f";
      base02 = "#393552";
      base03 = "#6e6a86";
      base04 = "#908caa";
      base05 = "#e0def4";
      base06 = "#f5e0dc";
      base07 = "#56526e";
      base08 = "#f38ba8"; # red
      base09 = "#fab387"; # orange
      base0A = "#f9e2af"; # yellow
      base0B = "#a6e3a1"; # green
      base0C = "#94e2d5"; # cyan
      base0D = "#89b4fa"; # "#c4a7e7"; # blue
      base0E = "#cba6f7"; # magenta
      base0F = "#f2cdcd"; # brown
    };
    fonts = {
      serif = {
        package = pkgs.nerd-fonts.agave;
        name = "Agave Nerd Font";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.arimo;
        name = "Arimo Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.agave;
        name = "Agave Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
