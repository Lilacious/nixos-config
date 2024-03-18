{
  lib,
  osConfig,
  ...
}:
with lib; let
  osCfg = osConfig.myModules.desktop;
in {
  options = {
    myHome.desktop = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
      };

      desktopEnvironment = {
        enable = mkOption {
          type = types.bool;
          default = osCfg.desktopEnvironment.enable;
        };
      };

      windowManager = {
        enable = mkOption {
          type = types.bool;
          default = osCfg.windowManager.enable;
        };

        wayland = mkOption {
          type = types.bool;
          default = osCfg.windowManager.wayland;
        };

        xserver = mkOption {
          type = types.bool;
          default = osCfg.windowManager.xserver;
        };
      };
    };
  };

  imports = [
    ./hyprland
  ];
}
