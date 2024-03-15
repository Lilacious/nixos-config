{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myModules.desktop;
in {
  imports = [
  ];

  options = {
    myModules.desktop = {
      enable = mkOption {
        type = types.bool;
        default = cfg.desktopEnvironment || windowManager;
      };

      desktopEnvironment = {
        enable = mkOption {
          type = types.bool;
          default = false;
        };
      };

      windowManager = {
        enable = mkOption {
          type = types.bool;
          default = cfg.wayland || cfg.xserver;
        };

        wayland = mkOption {
          type = types.bool;
          default = false;
        };

        xserver = mkOption {
          type = types.bool;
          default = false;
        };
      };
    };
  };
}
