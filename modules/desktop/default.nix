{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myModules.desktop;
in {
  imports = [
    ./common.nix
  ];

  options = {
    myModules.desktop = {
      enable = mkOption {
        type = types.bool;
        default = cfg.desktopEnvironment.enable || windowManager.enable;
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
