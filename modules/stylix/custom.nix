{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.stylix.myThemes.custom;
in
{
  options = {
    stylix.myThemes.custom = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
    stylix = {
      base16Scheme = {
        name = "Custom Dark Theme";
        variant = "dark";
        slug = "custom-dark-theme";
        base00 = "#232136";
        base01 = "#2a273f";
        base02 = "#393552";
        base03 = "#6e6a86";
        base04 = "#908caa";
        base05 = "#e0def4";
        base06 = "#f5e0dc";
        base07 = "#b4befe"; # lavender
        base08 = "#f38ba8"; # red
        base09 = "#fab387"; # orange
        base0A = "#f9e2af"; # yellow
        base0B = "#a6e3a1"; # green
        base0C = "#94e2d5"; # cyan
        base0D = "#89b4fa"; # "#c4a7e7"; # blue
        base0E = "#cba6f7"; # magenta
        base0F = "#f2cdcd"; # brown
        base10 = "#2a273f";
        base11 = "#1f1d30";
        base12 = "#eba0ac";
        base13 = "#f5e0dc";
        base14 = "#a6e3a1";
        base15 = "#89dceb"; # sky
        base16 = "#74c7ec"; # sapphire
        base17 = "#f5c2e7"; # pink
      };
    };
  };
}
