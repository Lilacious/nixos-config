# For system config see nix-config/modules/desktop/hyprland.nix
# macOS-style Hyprland, the same look as niri.nix (Apple's macOS 27 UI kit); the shell is
# noctalia.nix: bar, dock, launcher, notifications, OSD, lock screen and polkit agent
{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myHome.desktop.hyprland;
  osCfg = osConfig.myModules.desktop.hyprland;

  # hyprland.lua: each settings attribute becomes an hl.<name>(...) call, `_args` gives
  # several arguments and mkLuaInline writes raw Lua (the dispatchers)
  lua = generators.mkLuaInline;
  luaString = generators.toLua { };

  mod = "SUPER";
  # hl.bind("KEYS", dispatcher[, opts]); the menubar plugin reads these lines for the
  # shortcuts it shows, so a dispatcher stays on one line
  bind = keys: dispatcher: opts: {
    _args = [
      keys
      (lua dispatcher)
    ]
    ++ optional (opts != { }) opts;
  };
  exec = command: "hl.dsp.exec_cmd(${luaString command})";
  noctalia = cmd: exec "noctalia msg ${cmd}";
  screenshot = target: exec "grimblast --notify copysave ${target}";
  # bindel / bindl of the old config
  repeatLocked = {
    locked = true;
    repeating = true;
  };
  locked = {
    locked = true;
  };

  curve = name: points: {
    _args = [
      name
      {
        type = "bezier";
        inherit points;
      }
    ];
  };
  env = name: value: {
    _args = [
      name
      value
    ];
  };
in
{
  options = {
    myHome.desktop.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
      };
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      # hyprland.lua: Hyprland 0.56 warns on every start that it drops hyprland.conf in 0.57
      configType = "lua";
      # hand the whole session environment to systemd, as niri-session does: noctalia finds
      # its logind session through XDG_SESSION_ID, and apps it starts as systemd units get
      # the env values below (cursor, toolkit backends)
      systemd.variables = [ "--all" ];
      # deep merge, so host settings only override the keys they set
      settings = recursiveUpdate {
        config = {
          general = {
            # gaps_in is applied on both sides: 16pt between windows, like niri's gaps. 4pt
            # to the bar and the screen bottom (niri: gaps 16 with struts -12), 16pt at the sides
            gaps_in = 8;
            gaps_out = {
              top = 4;
              right = 16;
              bottom = 4;
              left = 16;
            };
            # the kit window's 1pt rim: 20% white, on inactive windows too
            border_size = 1;
            col = {
              active_border = "rgba(ffffff33)";
              inactive_border = "rgba(ffffff33)";
            };
            resize_on_border = true;
          };

          decoration = {
            rounding = 16;
            # big soft shadow for the focused window, a light one for the rest
            shadow = {
              enabled = true;
              range = 70;
              render_power = 3;
              offset = "0 20";
              color = "rgba(00000073)";
              color_inactive = "rgba(00000033)";
            };
            # macOS vibrancy: wide blur with boosted saturation (niri: passes 3, offset 3,
            # saturation 1.8). noctalia asks for blur behind its glass surfaces itself
            # (ext-background-effect), so they need no layer rules
            blur = {
              enabled = true;
              size = 3;
              passes = 3;
              noise = 2.0e-2;
              vibrancy = 0.5;
              # blur the windows behind glass, not only the wallpaper
              xray = false;
            };
          };

          animations.enabled = true;

          input = {
            # no compose key: on the German layout AltGr (right Alt) types @ € { } [ ] \ ~ |
            kb_layout = osConfig.services.xserver.xkb.layout;
            touchpad.tap_to_click = true;
          };

          cursor.hide_on_key_press = true;

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            # no middle click paste
            middle_click_paste = false;
          };

          # X11 apps render at native resolution instead of being upscaled blurry
          xwayland.force_zero_scaling = true;

          ecosystem = {
            no_donation_nag = true;
            no_update_news = true;
          };
        };

        # macOS-like motion as in niri.nix: nothing bounces; windows open with a quick
        # fade while zooming in from 94% and close shrinking to 95%; Spaces slide sideways.
        # home-manager writes curves first (importantPrefixes), before the animations
        curve = [
          (curve "macos" [
            [
              0.2
              0.8
            ]
            [
              0.2
              1.0
            ]
          ])
          (curve "easeOutQuad" [
            [
              0.25
              0.46
            ]
            [
              0.45
              0.94
            ]
          ])
          # a critically damped spring, no overshoot
          (curve "spring" [
            [
              0.25
              1.0
            ]
            [
              0.5
              1.0
            ]
          ])
        ];
        # speed in 100ms
        animation = [
          {
            leaf = "windowsIn";
            enabled = true;
            speed = 2.2;
            bezier = "macos";
            style = "popin 94%";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 1.8;
            bezier = "easeOutQuad";
            style = "popin 95%";
          }
          {
            leaf = "windowsMove";
            enabled = true;
            speed = 3;
            bezier = "spring";
          }
          # fully opaque by 60% of the way, so it never looks washed out
          {
            leaf = "fadeIn";
            enabled = true;
            speed = 1.3;
            bezier = "macos";
          }
          {
            leaf = "fadeOut";
            enabled = true;
            speed = 1.8;
            bezier = "easeOutQuad";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 4.5;
            bezier = "spring";
            style = "slide";
          }
          # noctalia animates its own bar, dock and panels; niri doesn't animate them either
          {
            leaf = "layers";
            enabled = false;
          }
          {
            leaf = "fadeLayers";
            enabled = false;
          }
          # both border colors are the same
          {
            leaf = "border";
            enabled = false;
          }
        ];

        bind =
          # Switch workspaces with mainMod + [1-9], move the window there with Shift
          concatMap (n: [
            (bind "${mod} + ${toString n}"
              "hl.dsp.focus({ workspace = ${toString n}, on_current_monitor = true })"
              { }
            )
            (bind "${mod} + SHIFT + ${toString n}"
              "hl.dsp.window.move({ workspace = ${toString n}, follow = false })"
              { }
            )
          ]) (range 1 9)
          ++ [
            (bind "CTRL + ALT + Delete" "hl.dsp.exit()" { })
            # Spotlight from the noctalia menubar plugin
            (bind "${mod} + Space" (noctalia "panel-toggle yunix/menubar:spotlight") { })
            (bind "${mod} + ALT + L" (noctalia "session lock") { })
            (bind "${mod} + Return" (exec osCfg.terminal) { })
            (bind "${mod} + B" (exec osCfg.browser) { })
            (bind "${mod} + F" "hl.dsp.window.fullscreen()" { })
            # monocle
            (bind "${mod} + M" ''hl.dsp.window.fullscreen({ mode = "maximized" })'' { })
            # dwindle
            (bind "${mod} + T" ''hl.dsp.layout("togglesplit")'' { })
            (bind "${mod} + P" "hl.dsp.window.pseudo()" { })
            (bind "${mod} + V" ''hl.dsp.window.float({ action = "toggle" })'' { })
            (bind "${mod} + V" "hl.dsp.window.center()" { })
            (bind "${mod} + Q" "hl.dsp.window.close()" { })
            # Move focus with mainMod + arrow keys
            (bind "${mod} + left" ''hl.dsp.focus({ direction = "left" })'' { })
            (bind "${mod} + right" ''hl.dsp.focus({ direction = "right" })'' { })
            (bind "${mod} + up" ''hl.dsp.focus({ direction = "up" })'' { })
            (bind "${mod} + down" ''hl.dsp.focus({ direction = "down" })'' { })
            (bind "${mod} + SHIFT + left" ''hl.dsp.window.move({ direction = "left" })'' { })
            (bind "${mod} + SHIFT + right" ''hl.dsp.window.move({ direction = "right" })'' { })
            (bind "${mod} + SHIFT + up" ''hl.dsp.window.move({ direction = "up" })'' { })
            (bind "${mod} + SHIFT + down" ''hl.dsp.window.move({ direction = "down" })'' { })
            # screenshots, saved to XDG_SCREENSHOTS_DIR and copied, as in niri
            (bind "Print" (screenshot "area") { })
            (bind "CTRL + Print" (screenshot "output") { })
            (bind "ALT + Print" (screenshot "active") { })
            # Move/resize windows with mainMod + LMB/RMB and dragging
            (bind "${mod} + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
            (bind "${mod} + mouse:273" "hl.dsp.window.resize()" { mouse = true; })
            # media keys through noctalia, which shows its OSD
            (bind "XF86AudioRaiseVolume" (noctalia "volume-up") repeatLocked)
            (bind "XF86AudioLowerVolume" (noctalia "volume-down") repeatLocked)
            (bind "XF86MonBrightnessUp" (noctalia "brightness-up") repeatLocked)
            (bind "XF86MonBrightnessDown" (noctalia "brightness-down") repeatLocked)
            (bind "XF86AudioMute" (noctalia "volume-mute") locked)
            (bind "XF86AudioMicMute" (noctalia "mic-mute") locked)
            (bind "XF86AudioPlay" (noctalia "media toggle") locked)
            (bind "XF86AudioPause" (noctalia "media pause") locked)
            (bind "XF86AudioStop" (noctalia "media stop") locked)
            (bind "XF86AudioNext" (noctalia "media next") locked)
            (bind "XF86AudioPrev" (noctalia "media previous") locked)
          ];

        env = [
          (env "GDK_BACKEND" "wayland,x11,*")
          (env "QT_QPA_PLATFORM" "wayland;xcb")
          (env "XDG_SCREENSHOTS_DIR" "${config.home.homeDirectory}/Pictures/Screenshots")
        ]
        # same theme and size as apps get from home.pointerCursor (theme.nix), so the
        # pointer doesn't change size between the desktop and app windows
        ++ optionals (config.home.pointerCursor != null) [
          (env "XCURSOR_THEME" config.home.pointerCursor.name)
          (env "XCURSOR_SIZE" (toString config.home.pointerCursor.size))
        ];
      } osCfg.settings;
    };

    home.packages = [ pkgs.grimblast ];
  };
}
