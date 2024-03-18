# For system config see nix-config/modules/desktop/hyprland.nix
{
  config,
  osConfig,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.desktop.hyprland;
  osCfg = osConfig.myModules.desktop.hyprland;
in {
  options = {
    myHome.desktop.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
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
