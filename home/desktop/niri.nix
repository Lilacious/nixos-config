# For system config see nix-config/modules/desktop/niri.nix
# macOS-style niri, matched to Apple's macOS 27 UI kit; the shell is noctalia.nix
{
  config,
  osConfig,
  lib,
  ...
}:
with lib;
let
  cfg = config.myHome.desktop.niri;
  osCfg = osConfig.myModules.desktop.niri;

  # Catppuccin Mocha Mauve, the shell's accent (see noctalia.nix)
  accent = "#cba6f7";

  # keybind helper to invoke noctalia
  noctalia = cmd: {
    _props.allow-when-locked = true;
    spawn-sh = "noctalia msg ${cmd}";
  };
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
          # no compose key: on the German layout AltGr (right Alt) types @ € { } [ ] \ ~ |
          keyboard.xkb.layout = cfg.settings.kbLayout;
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
        cursor = {
          # hide cursor while typing
          hide-when-typing = { };
        }
        # same theme and size as apps get from home.pointerCursor (theme.nix), so the
        # pointer doesn't change size between the desktop and app windows
        // optionalAttrs (config.home.pointerCursor != null) {
          xcursor-theme = config.home.pointerCursor.name;
          xcursor-size = config.home.pointerCursor.size;
        };
        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        # macOS vibrancy: wide blur with boosted saturation
        blur = {
          passes = 3;
          offset = 3;
          noise = 2.0e-2;
          saturation = 1.8;
        };

        layout = {
          gaps = 16;
          # 2/3 fits a 1536px wide laptop screen, Mod+R cycles the presets
          default-column-width.proportion = 0.66667;
          preset-column-widths._children = [
            { proportion = 0.5; }
            { proportion = 0.66667; }
            { proportion = 1.0; }
          ];
          struts = {
            left = 64;
            right = 64;
            # gaps 16 - 12 = 4pt between windows and the bar / screen bottom, same as the
            # dock's distance to the edge
            top = -12;
            bottom = -12;
          };
          # center lone windows
          always-center-single-column = { };
          # spare workspace on top
          empty-workspace-above-first = { };
          # shadows mark focus instead
          focus-ring.off = { };
          # the kit window's 1pt rim: 20% white (#4b4b4b on its #1e1e1e); macOS keeps it
          # on inactive windows too, only the shadow shrinks
          border = {
            on = { };
            width = 1;
            active-color = "#ffffff33";
            inactive-color = "#ffffff33";
            urgent-color = "#ff453a";
          };
          # big soft shadow for the focused window, a light one for the rest
          shadow = {
            on = { };
            softness = 70;
            spread = 0;
            offset._props = {
              x = 0;
              y = 20;
            };
            color = "#00000073";
            inactive-color = "#00000033";
          };
          tab-indicator = {
            hide-when-single-tab = { };
            position = "top";
            gaps-between-tabs = 10;
            corner-radius = 8;
            active-color = accent;
            inactive-color = "#ffffff33";
            urgent-color = "#ff453a";
          };
          insert-hint.color = "${accent}40";
        };

        window-rule = {
          geometry-corner-radius = 16;
          clip-to-geometry = true;
          # apps restoring a maximized state would drop gaps and corners
          open-maximized-to-edges = false;
          # new windows open as a maximized column (gaps and struts kept), Mod+Ctrl+M restores
          open-maximized = true;
        };

        overview = {
          backdrop-color = "#1e1e1e";
          workspace-shadow = {
            softness = 60;
            spread = 0;
            offset._props = {
              x = 0;
              y = 16;
            };
            color = "#00000059";
          };
        };

        # no hot corner: pushing the pointer into the top-left corner opened the overview
        gestures.hot-corners.off = { };

        # light selection tile like macOS, not an accent outline
        recent-windows.highlight = {
          active-color = "#ffffff26";
          urgent-color = "#ff453a";
          corner-radius = 16;
        };

        binds = {
          "Mod+Return".spawn = "ghostty";
          "Mod+B".spawn = "firefox";
          # Spotlight from the noctalia menubar plugin
          "Mod+Space".spawn-sh = "noctalia msg panel-toggle yunix/menubar:spotlight";
          # keybind cheatsheet
          "Mod+O".show-hotkey-overlay = { };
          "Mod+Q".close-window = { };
          # same as an app's own maximize button: fill the screen, no gaps or struts
          "Mod+M".maximize-window-to-edges = { };
          # widen the column to the working area, keeping gaps and struts
          "Mod+Ctrl+M".maximize-column = { };
          "Alt+Ctrl+Delete".quit = { };
          "Mod+Alt+L".spawn-sh = "noctalia msg session lock";

          # focus with arrows and vim keys
          "Mod+Left".focus-column-left = { };
          "Mod+Down".focus-window-down = { };
          "Mod+Up".focus-window-up = { };
          "Mod+Right".focus-column-right = { };
          "Mod+H".focus-column-left = { };
          "Mod+J".focus-window-down = { };
          "Mod+K".focus-window-up = { };
          "Mod+L".focus-column-right = { };

          # move, Shift moves what Mod alone focuses
          "Mod+Shift+Left".move-column-left = { };
          "Mod+Shift+Down".move-window-down = { };
          "Mod+Shift+Up".move-window-up = { };
          "Mod+Shift+Right".move-column-right = { };
          "Mod+Shift+H".move-column-left = { };
          "Mod+Shift+J".move-window-down = { };
          "Mod+Shift+K".move-window-up = { };
          "Mod+Shift+L".move-column-right = { };

          # workspaces, Shift takes the column along
          "Mod+U".focus-workspace-down = { };
          "Mod+I".focus-workspace-up = { };
          "Mod+Page_Down".focus-workspace-down = { };
          "Mod+Page_Up".focus-workspace-up = { };
          "Mod+Shift+U".move-column-to-workspace-down = { };
          "Mod+Shift+I".move-column-to-workspace-up = { };
          "Mod+Shift+Page_Down".move-column-to-workspace-down = { };
          "Mod+Shift+Page_Up".move-column-to-workspace-up = { };
          "Mod+WheelScrollDown" = {
            _props.cooldown-ms = 150;
            focus-workspace-down = { };
          };
          "Mod+WheelScrollUp" = {
            _props.cooldown-ms = 150;
            focus-workspace-up = { };
          };

          # monitors, Ctrl focuses and Ctrl+Shift moves the column
          "Mod+Ctrl+Left".focus-monitor-left = { };
          "Mod+Ctrl+Down".focus-monitor-down = { };
          "Mod+Ctrl+Up".focus-monitor-up = { };
          "Mod+Ctrl+Right".focus-monitor-right = { };
          "Mod+Ctrl+Shift+Left".move-column-to-monitor-left = { };
          "Mod+Ctrl+Shift+Down".move-column-to-monitor-down = { };
          "Mod+Ctrl+Shift+Up".move-column-to-monitor-up = { };
          "Mod+Ctrl+Shift+Right".move-column-to-monitor-right = { };

          # sizing
          "Mod+F".fullscreen-window = { };
          "Mod+C".center-column = { };
          "Mod+Ctrl+F".expand-column-to-available-width = { }; # fill free space
          "Mod+R".switch-preset-column-width = { }; # 1/3, 1/2, 2/3
          "Mod+Shift+R".switch-preset-column-width-back = { };
          "Mod+Ctrl+R".reset-window-height = { };
          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          # columns, tabs and floating
          "Mod+BracketLeft".consume-or-expel-window-left = { }; # stack into column
          "Mod+BracketRight".consume-or-expel-window-right = { };
          "Mod+W".toggle-column-tabbed-display = { };
          "Mod+V".toggle-window-floating = { };
          "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };

          # screenshots, saved to screenshot-path and copied
          "Print".screenshot = { }; # select region
          "Ctrl+Print".screenshot-screen = { };
          "Alt+Print".screenshot-window = { };

          # media keys
          "XF86AudioRaiseVolume" = noctalia "volume-up";
          "XF86AudioLowerVolume" = noctalia "volume-down";
          "XF86AudioMute" = noctalia "volume-mute";
          "XF86AudioMicMute" = noctalia "mic-mute";
          "XF86AudioPlay" = noctalia "media toggle";
          "XF86AudioPause" = noctalia "media pause";
          "XF86AudioStop" = noctalia "media stop";
          "XF86AudioNext" = noctalia "media next";
          "XF86AudioPrev" = noctalia "media previous";
          "XF86MonBrightnessUp" = noctalia "brightness-up";
          "XF86MonBrightnessDown" = noctalia "brightness-down";
        }
        // genAttrs' (range 1 9) (n: nameValuePair "Mod+${toString n}" { focus-workspace = n; })
        // genAttrs' (range 1 9) (
          n: nameValuePair "Mod+Shift+${toString n}" { move-column-to-workspace = n; }
        );
      };

      # written as KDL: settings can't repeat a node (layer-rule) and would flatten the
      # shaders into one escaped line
      extraConfig = ''
        // glass surfaces blur the windows behind them, not only the wallpaper (xray);
        // the fullscreen noctalia-panel-click-shield must stay out of this
        layer-rule {
            match namespace="^noctalia-(panel|attached-panel|osd|notification.*|window-switcher)$"
            background-effect {
                blur true
                xray false
            }
        }
        // the dock requests its own blur (ext-background-effect) in its exact shape and
        // clears it while auto-hidden; "blur true" here would blur the whole surface and
        // leave a dark rectangle when the dock slides away. Only switch it from xray to
        // the windows behind.
        layer-rule {
            match namespace="^noctalia-dock$"
            background-effect {
                xray false
            }
        }
        // blurred wallpaper behind the overview, like Mission Control
        layer-rule {
            match namespace="^noctalia-backdrop"
            place-within-backdrop true
        }

        // macOS-like motion: nothing bounces (damping 1.0 everywhere); Spaces and Mission
        // Control are a little heavier than niri's defaults, windows open and close with
        // a small zoom and fade instead of growing from half size
        animations {
            // Spaces: a smooth ~0.45s slide (niri default stiffness 1000 is ~0.3s)
            workspace-switch {
                spring damping-ratio=1.0 stiffness=400 epsilon=0.0001
            }
            // Mission Control: ~0.35s
            overview-open-close {
                spring damping-ratio=1.0 stiffness=700 epsilon=0.0001
            }
            // a quick fade while zooming in from 94%, easing out
            window-open {
                duration-ms 220
                curve "cubic-bezier" 0.2 0.8 0.2 1
                custom-shader r"
                    vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                        float p = niri_clamped_progress;
                        float scale = 0.94 + 0.06 * p;
                        coords_geo = vec3((coords_geo.xy - vec2(0.5)) / scale + vec2(0.5), 1.0);
                        vec3 coords_tex = niri_geo_to_tex * coords_geo;
                        vec4 color = texture2D(niri_tex, coords_tex.st);
                        // fully opaque by 60% of the way, so it never looks washed out
                        return color * min(1.0, p / 0.6);
                    }
                "
            }
            // fade out while shrinking slightly to 95%
            window-close {
                duration-ms 180
                curve "ease-out-quad"
                custom-shader r"
                    vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                        float p = niri_clamped_progress;
                        float scale = 1.0 - 0.05 * p;
                        coords_geo = vec3((coords_geo.xy - vec2(0.5)) / scale + vec2(0.5), 1.0);
                        vec3 coords_tex = niri_geo_to_tex * coords_geo;
                        vec4 color = texture2D(niri_tex, coords_tex.st);
                        return color * (1.0 - p);
                    }
                "
            }
            // the reload notice and exit dialog bounce by default; macOS doesn't
            config-notification-open-close {
                spring damping-ratio=1.0 stiffness=1000 epsilon=0.001
            }
            exit-confirmation-open-close {
                spring damping-ratio=1.0 stiffness=800 epsilon=0.01
            }
        }
      '';
    };
  };
}
