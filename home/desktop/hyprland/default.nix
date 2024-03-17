# For system config see nix-config/modules/desktop/hyprland.nix
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.desktop.hyprland;
in {
  options = {
    myHome.desktop.hyprland = {
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
        type = with lib.types; let
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
            ",preferred,auto,auto"
          ];
        };
      };
    };
  };

  imports = [
    ./binds.nix
    ./settings.nix
    ./utilities.nix
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.enable = true;
  };
}
