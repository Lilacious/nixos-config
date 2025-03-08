{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  WM = config.myModules.desktop.windowManager;
  DE = config.myModules.desktop.desktopEnvironment;
in
{
  imports = [
    ./cosmic.nix
    ./display-manager.nix
    ./gnome.nix
    ./plasma.nix
    ./plymouth.nix
  ];

  options = {
    myModules.desktop = {
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

  config = mkIf config.myModules.desktop.enable {
    programs.firefox.enable = true;

    # Enable audio
    myModules = {
      other.fonts.enable = true;
      programs.desktop.enable = true;
      services.audio.enable = true;
    };

    services.xserver = {
      # Disable xserver by default
      enable = mkDefault false;
      # Set keymap to German
      xkb.layout = mkDefault "de";
      # Disable xterm
      excludePackages = with pkgs; [ xterm ];
    };

    # Enable polkit
    security.polkit.enable = true;
    # Run GNOME applications
    programs.dconf.enable = true;
  };
}
