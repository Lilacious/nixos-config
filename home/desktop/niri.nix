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

  # accent for the insert hint, falls back to niri's default
  accent = if options ? stylix then config.lib.stylix.colors.withHashtag.base0D else "#ffc87f";
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
          default = osConfig.services.xserver.xkb.layout;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.niri = {
      enable = true;
      package = osConfig.programs.niri.package;
      systemd.enable = false;
      xwaylandSatellitePackage = null;
      portalPackage = null;

      settings = {
        input = {
          keyboard.xkb = {
            layout = cfg.settings.kbLayout;
            options = "compose:ralt";
          };
          # tap to click
          touchpad.tap = { };
          tablet.map-to-output = "eDP-1";
          touch.map-to-output = "eDP-1";
          # same workspace key jumps back
          workspace-auto-back-and-forth = { };
          # let the power button be controlled by noctalia
          disable-power-key-handling = { };
        };

        # prefer no titlebars
        prefer-no-csd = { };
        # no keybind popup on login
        hotkey-overlay.skip-at-startup = { };
        # no middle click paste
        clipboard.disable-primary = { };
        # hide cursor while typing
        cursor.hide-when-typing = { };
        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        layout = {
          gaps = 16;
          struts = {
            left = 64;
            right = 64;
          };
          # center lone windows
          always-center-single-column = { };
          # spare workspace on top
          empty-workspace-above-first = { };
          # shadows mark focus instead
          focus-ring.off = { };
          border = {
            on = { };
            width = 1;
            active-color = "#ffffff1f";
            inactive-color = "#ffffff0d";
          };
          shadow = {
            # soft depth, darker when active
            on = { };
            softness = 40;
            spread = 2;
            offset._props = {
              x = 0;
              y = 10;
            };
            color = "#00000080";
            inactive-color = "#00000040";
          };
          tab-indicator = {
            hide-when-single-tab = { };
            position = "top";
            gaps-between-tabs = 10;
            corner-radius = 8;
          };
          insert-hint.color = "${accent}40";
        };

        window-rule = {
          geometry-corner-radius = 12;
          clip-to-geometry = true;
        };

        recent-windows.highlight.corner-radius = 12;

        binds = {
          "Mod+Return".spawn = "ghostty";
          "Mod+B".spawn = "firefox";
          "Mod+Space".spawn = "fuzzel";
          # keybind cheatsheet
          "Mod+O".show-hotkey-overlay = { };
          "Mod+Q".close-window = { };
          "Mod+M".maximize-column = { };
          "Alt+Ctrl+Delete".quit = { };

          # focus with arrows and vim keys
          "Mod+Left".focus-column-left = { };
          "Mod+Down".focus-window-down = { };
          "Mod+Up".focus-window-up = { };
          "Mod+Right".focus-column-right = { };
          "Mod+H".focus-column-left = { };
          "Mod+J".focus-window-down = { };
          "Mod+K".focus-window-up = { };
          "Mod+L".focus-column-right = { };
        }
        // genAttrs' (range 1 9) (n: nameValuePair "Mod+${toString n}" { focus-workspace = n; });
      };
    };

    myHome.programs.fuzzel.enable = true;
  };
}
