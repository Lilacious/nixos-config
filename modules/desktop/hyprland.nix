# For home config see nix-config/home/desktop/hyprland.nix
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myModules.desktop.hyprland;
in {
  options = {
    myModules.desktop.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (cfg.enable) {
    myModules.desktop.windowManager.wayland = true;

    programs.hyprland.enable = true;
  };
}
