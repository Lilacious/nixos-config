{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.services.hyprpaper;
  HL = config.myHome.desktop.hyprland;
in {
  options = {
    myHome.services.hyprpaper = {
      enable = mkOption {
        type = types.bool;
        default = HL.enable;
      };
    };
  };
  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      preloads = [
        "~/Pictures/Wallpapers/tokyo-cozy.png"
      ];
      wallpapers = [
        ",~/Pictures/Wallpapers/tokyo-cozy.png"
      ];
    };
  };
}
