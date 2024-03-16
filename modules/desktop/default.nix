{
  config,
  lib,
  ...
}:
with lib; let
  WM = config.myModules.desktop.windowManager;
  DE = config.myModules.desktop.desktopEnvironment;
in {
  imports = [
    ./audio.nix
    ./common.nix
    ./display-manager.nix
    ./hyprland.nix
    ./plasma.nix
  ];

  options = {
    myModules.desktop = {
      enable = mkOption {
        type = types.bool;
        default = WM.enable || DE.enable;
      };

      displayManager = {
        enable = mkOption {
          type = types.str;
          default = "sddm";
        };
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
}
