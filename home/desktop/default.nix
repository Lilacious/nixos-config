{
  lib,
  config,
  ...
}:
with lib; let
  WM = config.myHome.desktop.windowManager;
  DE = config.myHome.desktop.desktopEnvironment;
in {
  options = {
    myHome.desktop = {
      enable = mkOption {
        type = types.bool;
        default = WM.enable || DE.enable;
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
          default = WM.wayland || WM.xserver;
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

  imports = [
    ./hyprland
  ];
}
