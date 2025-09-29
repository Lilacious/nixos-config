# For system config see nix-config/modules/desktop/plasma.nix
{
  inputs,
  options,
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.myHome.desktop.plasma;
  osCfg = osConfig.myModules.desktop.plasma;
  inherit (config.programs.plasma.kwin.nightLight) mode;
in
{
  options = {
    myHome.desktop.plasma = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
      };
    };
  };

  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  config = mkIf cfg.enable (mkMerge [
    {
      programs = {
        plasma = {
          enable = true;

          kwin = {
            nightLight = {
              enable = true;
              mode = "location";
              # mode capitalized by option
              location = mkIf (mode == "Location") {
                # Frankfurt
                latitude = "50.110556";
                longitude = "8.682222";
              };
              temperature = {
                day = null;
                night = 4000;
              };
            };
          };

          workspace = {
            clickItemTo = "select";
            enableMiddleClickPaste = false;

            lookAndFeel = null;
            theme = "default";
            iconTheme = "WhiteSur";
            cursor.theme = "WhiteSur-cursors";
          };

          shortcuts = {
            "Alacritty.desktop" = {
              "_launch" = "Meta+Return";
            };
            "firefox.desktop" = {
              "_launch" = "Meta+B"; # Browser
            };
            "org.kde.dolphin.desktop" = {
              "_launch" = "Meta+E"; # Explorer
            };
            "kwin" = {
              "Window Close" = [
                "Meta+Q"
                "Alt+F4"
              ];
              "Window Maximize" = "Meta+M";
              "Window Fullscreen" = "Meta+Shift+M";
            };
            "org_kde_powerdevil" = {
              "powerProfile" = [
                "Battery"
                "Meta+P"
              ];
            };
          };

          configFile = {
            kwinrc = {
              # Disable hot corner
              ElectricBorders.TopLeft = "";
            };
          };
        };
      };
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          stylix.targets.kde.enable = true;
          programs.plasma.workspace.colorScheme = "CustomDarkTheme";
        }
      else
        {
          home.packages = with pkgs; [

            (catppuccin-kde.override {
              flavour = [ "mocha" ];
              accents = [ "mauve" ];
              winDecStyles = [ "modern" ];
            })
          ];
          programs.plasma.workspace.colorScheme = "CatppuccinMochaMauve";
        }
    )
  ]);
}
