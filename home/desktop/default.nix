{
  lib,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfg = config.myHome.desktop;
  osCfg = osConfig.myModules.desktop;
in
{
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
    ./gnome.nix
    ./hyprland.nix
    #./niri.nix
    ./plasma.nix
    ./theme.nix
  ];

  config = mkIf cfg.enable {
    myHome = {
      programs = {
        alacritty.enable = true;
        direnv.enable = true;
        zathura.enable = true;
        zellij.enable = true;
      };
      # Use the home-manager module on graphical systems
      services.syncthing.enable = true;
    };
  };
}
