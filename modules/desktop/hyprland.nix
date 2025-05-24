# For home config see nix-config/home/desktop/hyprland.nix
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop.hyprland;
in
{
  options = {
    myModules.desktop.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      terminal = mkOption {
        type = types.str;
        default = "alacritty";
      };

      browser = mkOption {
        type = types.str;
        default = "firefox";
      };

      settings = mkOption {
        type =
          with lib.types;
          let
            valueType =
              nullOr (oneOf [
                bool
                int
                float
                str
                path
                (attrsOf valueType)
                (listOf valueType)
              ])
              // {
                description = "Hyprland configuration value";
              };
          in
          valueType;
        default = {
          monitor = [
            ",preferred,auto,1"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    myModules.desktop.windowManager.wayland = true;

    programs.hyprland.enable = true;
  };
}
