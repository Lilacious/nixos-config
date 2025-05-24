# For system config see nix-config/modules/desktop/niri.nix
{
  config,
  osConfig,
  lib,
  options,
  ...
}:
with lib;
let
  cfg = config.myHome.desktop.niri;
  osCfg = osConfig.myModules.desktop.niri;
in
{
  options = {
    myHome.desktop.niri = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
      };
      settings = {
        kbLayout = mkOption {
          type = types.str;
          default = "de";
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      myHome.programs = {
        fuzzel.enable = true;
        #mako.enable = true;
      };
      programs.niri.settings = {
        input = {
          keyboard.xkb.layout = cfg.settings.kbLayout;
          touchpad.natural-scroll = false;
          tablet.map-to-output = "eDP-1";
          touch.map-to-output = "eDP-1";
        };
        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;
        clipboard.disable-primary = true;
        layout = {
          gaps = 16;
          struts.left = 64;
          struts.right = 64;
          border.width = 2;
          always-center-single-column = true;
          empty-workspace-above-first = true;

          shadow.enable = true;

          tab-indicator = {
            position = "top";
            gaps-between-tabs = 10;
          };
        };
        binds =
          with config.lib.niri.actions;
          let
            workspace =
              pref: action:
              builtins.listToAttrs (
                map (
                  n:
                  lib.nameValuePair "${pref}${toString n}" {
                    action = action n;
                  }
                ) (range 1 9)
              );
            focus = workspace "Mod+" focus-workspace;
            #move = workspace "Mod+Shift+" move-window-to-workspace;

            extraBinds = focus; # // move;
          in
          {
            "Mod+Return".action.spawn = "alacritty";
            "Mod+B".action.spawn = "firefox";
            "Mod+Space".action.spawn = "fuzzel";
            "Mod+O".action = show-hotkey-overlay;
            "Mod+Q".action = close-window;
            "Mod+M".action = maximize-column;
            "Alt+Control+Delete".action = quit;

            "Mod+Left".action = focus-column-left;
            "Mod+Down".action = focus-window-down;
            "Mod+Up".action = focus-window-up;
            "Mod+Right".action = focus-column-right;
            "Mod+H".action = focus-column-left;
            "Mod+J".action = focus-window-down;
            "Mod+K".action = focus-window-up;
            "Mod+L".action = focus-column-right;
          }
          // extraBinds;
      };
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          stylix.targets.niri.enable = true;
        }
      else
        { }
    )
  ]);
}
