# Shell for niri and Hyprland, for system config see nix-config/modules/desktop/noctalia.nix
# macOS Tahoe look: transparent menu bar, glass dock and panels, Apple system colors with
# Catppuccin Mauve as the accent. Sizes follow Apple's macOS 27 UI kit, scaled to this
# 1536x864 screen like a Mac without a notch (x 0.88 for the bar, x 0.96 for the dock).
{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myHome.desktop.noctalia;
  osCfg = osConfig.programs.noctalia;

  # Catppuccin Mauve: Mocha with Mocha's base as text on it, Latte with white
  accent = {
    dark = "#cba6f7";
    onDark = "#1e1e2e";
    light = "#8839ef";
    onLight = "#ffffff";
  };

  # macOS-style menu bar plugin: Apple menu, app menu, Spotlight, Control Center
  menubar = pkgs.callPackage ../../pkgs/noctalia-menubar/package.nix { };

  # lock screen items are laid out on this screen; the size is part of the layout so
  # noctalia has nothing to normalize and never saves its own copy to settings.toml,
  # which would override this config
  lockscreenItem =
    attrs:
    {
      output = "eDP-1";
      rotation = 0.0;
      placement_width = 1536.0;
      placement_height = 864.0;
    }
    // attrs;
in
{
  options = {
    myHome.desktop.noctalia = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.dataFile."noctalia/plugins/menubar".source = "${menubar}/share/noctalia/plugins/menubar";

    programs.noctalia = {
      enable = true;
      # same package as the system, used to validate the config at build time
      inherit (osCfg) package;
      # started by the system module, bound to niri.service and hyprland-session.target

      # Apple system colors (dark and light mode); accent and menu highlight in Mauve
      customPalettes.Apple = {
        dark = {
          mPrimary = accent.dark;
          mOnPrimary = accent.onDark;
          mSecondary = "#98989d";
          mOnSecondary = "#1c1c1e";
          mTertiary = "#30d158";
          mOnTertiary = "#000000";
          mError = "#ff453a";
          mOnError = "#ffffff";
          mSurface = "#1e1e1e";
          mOnSurface = "#f5f5f7";
          mSurfaceVariant = "#2c2c2e";
          mOnSurfaceVariant = "#98989d";
          mOutline = "#3a3a3c";
          mShadow = "#000000";
          # macOS highlights the item under the pointer in the accent
          mHover = accent.dark;
          mOnHover = accent.onDark;
          terminal = {
            foreground = "#f5f5f7";
            background = "#1e1e1e";
            cursor = "#f5f5f7";
            cursorText = "#1e1e1e";
            selectionFg = "#ffffff";
            selectionBg = "#3f638b";
            normal = {
              black = "#1e1e1e";
              red = "#ff453a";
              green = "#32d74b";
              yellow = "#ffd60a";
              blue = "#0a84ff";
              magenta = "#bf5af2";
              cyan = "#64d2ff";
              white = "#e5e5e7";
            };
            bright = {
              black = "#636366";
              red = "#ff6961";
              green = "#30db5b";
              yellow = "#ffd426";
              blue = "#409cff";
              magenta = "#da8fff";
              cyan = "#70d7ff";
              white = "#ffffff";
            };
          };
        };
        light = {
          mPrimary = accent.light;
          mOnPrimary = accent.onLight;
          mSecondary = "#8e8e93";
          mOnSecondary = "#ffffff";
          mTertiary = "#34c759";
          mOnTertiary = "#ffffff";
          mError = "#ff3b30";
          mOnError = "#ffffff";
          mSurface = "#f5f5f7";
          mOnSurface = "#1d1d1f";
          mSurfaceVariant = "#ffffff";
          mOnSurfaceVariant = "#6e6e73";
          mOutline = "#d2d2d7";
          mShadow = "#000000";
          mHover = accent.light;
          mOnHover = accent.onLight;
          terminal = {
            foreground = "#1d1d1f";
            background = "#ffffff";
            cursor = "#1d1d1f";
            cursorText = "#ffffff";
            selectionFg = "#1d1d1f";
            selectionBg = "#b3d7ff";
            normal = {
              black = "#1d1d1f";
              red = "#ff3b30";
              green = "#28cd41";
              yellow = "#ffcc00";
              blue = "#007aff";
              magenta = "#af52de";
              cyan = "#55bef0";
              white = "#d2d2d7";
            };
            bright = {
              black = "#8e8e93";
              red = "#d70015";
              green = "#248a3d";
              yellow = "#b25000";
              blue = "#0040dd";
              magenta = "#8944ab";
              cyan = "#0071a4";
              white = "#f5f5f7";
            };
          };
        };
      };

      settings = {
        # ── Menu bar ──
        bar.default = {
          position = "top";
          thickness = 23; # like a Mac without a notch: 24pt on ~900pt, the same share of this 864pt screen
          padding = 9; # kit 10 x 0.88
          widget_spacing = 0; # macOS items touch; the gap comes from each item's 10.5pt padding
          font_scale = 0.85; # kit text height x 0.88 (Inter measured against SF)
          margin_ends = 0; # full width
          concave_edge_corners = false;
          radius = 0;
          radius_top_left = 0;
          radius_top_right = 0;
          radius_bottom_left = 0;
          radius_bottom_right = 0;
          background_opacity = 0.0; # sits directly on the wallpaper
          compositor_blur = false; # Tahoe's menu bar is clear, not frosted
          shadow = false;
          # every widget is a macOS menu bar item: invisible 16pt pill, ~9pt side padding (kit x 0.88)
          capsule = true;
          capsule_fill = "#00000000";
          capsule_opacity = 0.0;
          capsule_border_width = 0.0;
          capsule_padding = 8.0; # kit 10.5pt x 0.88, as measured on screen
          capsule_thickness = 0.706; # the kit's pill-to-bar ratio (24 / 34): 16pt here
          capsule_radius = 8.0; # half the pill height: fully round
          hover_highlight = true;
          # left: logo, app name, menu titles, now playing; center stays free so the long right side has room
          # right: tray, indicators and toggles, then the macOS core (battery, wifi, spotlight, control center, clock)
          # File … Help are placeholders for now: plain text, no menus behind them
          start = [
            "menubar_logo"
            "menubar_app"
            "menubar_file"
            "menubar_edit"
            "menubar_view"
            "menubar_window_menu"
            "menubar_help"
            "menubar_media"
          ];
          center = [ ];
          end = [
            "menubar_extras"
            "menubar_keyboard"
            "menubar_lock_keys"
            "menubar_privacy"
            "menubar_caffeine"
            "menubar_nightlight"
            "menubar_clipboard"
            "menubar_notifications"
            "menubar_volume"
            "menubar_bluetooth"
            "menubar_battery"
            "menubar_network"
            "menubar_spotlight"
            "menubar_control_center"
            "menubar_clock"
          ];
        };

        widget = {
          # ── Left ──
          menubar_logo = {
            # same capsule as the other items; the widget draws its own 8pt padding and open-pill
            capsule_padding = 0.0;
            # snowflake instead of the apple logo; drops down the plugin's Apple menu
            type = "yunix/menubar:logo";
          };
          menubar_app = {
            capsule_padding = 0.0; # same as the logo
            # bold name of the focused app ("Finder" on an empty workspace); click for its app menu
            font_weight = 700;
            type = "yunix/menubar:app";
          };
          menubar_media = {
            # cover and title while something plays
            art_size = 16.0;
            max_length = 200.0;
            hide_artist = true;
            hide_when_no_media = true;
            type = "media";
          };

          # ── Right: tray ──
          menubar_extras.type = "tray";

          # ── Right: indicators and toggles ──
          menubar_keyboard = {
            # appears once a second layout is configured
            hide_when_single_layout = true;
            show_glyph = false;
            type = "keyboard_layout";
          };
          menubar_lock_keys = {
            # only while caps lock is on
            show_num_lock = false;
            hide_when_off = true;
            type = "lock_keys";
          };
          menubar_privacy = {
            # orange like the macOS recording dot, hidden while nothing records
            hide_inactive = true;
            active_color = "#ff9f0a";
            type = "privacy";
          };
          menubar_caffeine.type = "caffeine";
          menubar_nightlight.type = "nightlight";
          menubar_clipboard.type = "clipboard";
          menubar_notifications.type = "notifications";
          menubar_volume = {
            show_label = false;
            type = "volume";
          };
          menubar_bluetooth.type = "bluetooth";

          # ── Right: macOS core ──
          menubar_battery = {
            # battery glyph with the percentage next to it, like macOS with "Show Percentage"
            display_mode = "glyph";
            show_label = true;
            type = "battery";
          };
          menubar_network = {
            show_label = false;
            type = "network";
          };
          menubar_spotlight = {
            # magnifier opens the menubar plugin's Spotlight (also Mod+Space)
            glyph = "search";
            type = "custom_button";
            actions.left = "panel-toggle yunix/menubar:spotlight";
          };
          menubar_control_center = {
            # switches icon; opens the macOS-style Control Center from the menubar plugin and
            # lights up while it is open, right-click opens noctalia's full one
            type = "yunix/menubar:control";
            capsule_padding = 0.0; # the widget pads itself, like the logo and app name
            actions.right = "panel-toggle control-center";
          };
          menubar_clock = {
            format = "{:%a %d %b  %H:%M}"; # macOS 27 leaves a wider gap before the time
            tooltip_format = "{:%A, %d %B %Y}";
            type = "clock";
          };
        }
        # placeholder menu titles, regular weight like macOS; nothing opens yet
        //
          mapAttrs'
            (
              name: text:
              nameValuePair "menubar_${name}" {
                inherit text;
                font_weight = 400;
                type = "text";
              }
            )
            {
              file = "File";
              edit = "Edit";
              view = "View";
              window_menu = "Window";
              help = "Help";
            };

        # ── Dock ──
        dock = {
          # smart auto-hide: shown on an empty workspace and in the overview, otherwise hidden
          # until the pointer reaches the bottom edge; windows use the full height
          smart_auto_hide = true;
          reserve_space = false;
          enabled = true;
          # the macOS 27 dock from Apple's UI kit (58pt, 36pt icons, 9pt gaps, ~15pt radius)
          # x 0.96: the same share of screen height as on a Mac without a notch (6.4%)
          icon_size = 34;
          cross_axis_padding = 5; # 34 + 2 x 5 + dot row = 56pt
          main_axis_padding = 8; # whole numbers only: noctalia drops fractions and falls back to 16
          item_spacing = 8;
          margin_edge = 4; # floats 4pt above the screen edge, as in the kit
          radius = 14;
          radius_top_left = 14;
          radius_top_right = 14;
          radius_bottom_left = 14;
          radius_bottom_right = 14;
          concave_edge_corners = false; # floating, so no flared base
          background_opacity = 0.3; # glass; the dock asks the compositor to blur behind it
          border_width = 1.0; # hairline edge on the glass
          shadow = true;
          magnification = false; # off by default on macOS
          show_dots = true; # running apps
          show_instance_count = false;
          # same size and opacity for every icon
          inactive_scale = 1.0;
          inactive_opacity = 1.0;
          pinned = [
            "firefox"
            "codium"
            "com.mitchellh.ghostty"
            "thunderbird"
            "signal"
            "spotify"
          ];
        };

        # ── Shell & panels ──
        shell = {
          polkit_agent = true; # niri and Hyprland have no polkit agent of their own
          # own unit per launched app, so restarting noctalia.service doesn't kill their processes
          launch_apps_as_systemd_services = true;
          setup_wizard_enabled = false; # no setup popup on first login
          settings_window_translucent = true;
          # Tahoe controls are filled, not outlined; text fields keep their border
          button_borders = false;
          card_borders = false;
          input_borders = true;
          corner_radius_scale = 1.25; # Tahoe uses larger radii than Material

          animation.speed = 1.3; # macOS menus and popovers appear almost instantly

          # keep the login screen's wallpaper, colors and font in step with the shell
          # (passwordless through services.displayManager.noctalia-greeter.passwordlessSyncUsers)
          greeter_sync.auto_sync = true;

          panel = {
            transparency_mode = "glass";
            borders = true; # hairline edge on glass
            shadow = true;
            # panels float below the menu bar like macOS popovers instead of growing out of it
            control_center_placement = "floating";
            wallpaper_placement = "floating";
            floating_offset = 6;
            # menus drop down under the bar item that was clicked, like on macOS;
            # opened by keybind or IPC they fall back to the bar's center
            clipboard_placement = "floating";
            clipboard_position = "auto"; # defaults to center, which would ignore the click
            open_near_click_control_center = true;
            open_near_click_clipboard = true;
            open_near_click_wallpaper = true;
          };

          shadow.alpha = 0.35; # large and soft rather than dark
        };

        # noctalia's full Control Center (right-click the toggle icon): tiles in macOS order
        control_center = {
          # no power button: the session actions live in the Apple menu, as on macOS
          show_session_button = false;
          width = 600; # the narrowest allowed, closer to macOS's slim menus
          shortcuts = map (type: { inherit type; }) [
            "wifi"
            "bluetooth"
            "notification"
            "nightlight"
            "power_profile"
          ];
        };

        # ── Idle (macOS battery defaults) ──
        # lock and turn the display off together after 5 min, sleep after 15 min; a locked
        # screen goes dark after 1 min. Only while caffeine is off, see hooks.
        idle.behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 300.0;
          };
          screen-off = {
            action = "screen_off";
            enabled = true;
            timeout = 300.0;
            locked_timeout = 60.0;
          };
          lock-and-suspend = {
            action = "lock_and_suspend";
            enabled = true;
            timeout = 900.0;
          };
        };

        # ── Notifications & OSD ──
        notification = {
          position = "top_right";
          # kit: 16pt from the screen edge, 15pt under the bar; x 0.88 like the bar
          offset_x = 14;
          offset_y = 13;
          width = 344; # macOS banner width (this screen is as wide as the kit's)
          scale = 0.85; # kit: 13pt title and body, 72pt card for three lines
          show_app_name = false; # macOS shows only the icon, title, body and time
          background_opacity = 0.75; # glass
          border = true;
          border_width = 1.0;
        };

        osd = {
          # bottom centre above the dock, like older macOS: top right (Tahoe) covers the
          # Control Center while its sliders are dragged
          position = "bottom_center";
          orientation = "horizontal";
          offset_y = 13; # above the dock (noctalia counts from its top), the gap notifications keep under the bar
          background_opacity = 0.75; # glass
          border = true;
          border_width = 1.0;
          hide_delay_ms = 1500;
          # macOS only shows a HUD for hardware keys
          kinds = {
            wifi = false;
            bluetooth = false;
            power_profile = false;
            caffeine = false;
            nightlight = false;
            dnd = false; # the Focus tile shows it
          };
        };

        # ── Lock screen & overview backdrop ──
        lockscreen = {
          transition = [ "fade" ];
          transition_duration = 500.0;
          # macOS shows the wallpaper sharp, only slightly dimmed
          blur_intensity = 0.0;
          tint_intensity = 0.15;
        };

        # macOS lock screen: the date and a large clock top centre, a slim password field
        # near the bottom; no media, weather or session buttons
        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = [
            "date"
            "time"
            "lockscreen-login-box@eDP-1"
          ];
          widget = {
            date = lockscreenItem {
              type = "clock";
              cx = 768.0;
              cy = 56.0;
              box_width = 360.0;
              box_height = 30.0; # about a quarter of the clock, like macOS
              settings = {
                format = "{:%A %d %B}";
                center_text = true;
                color = "#ffffffd9";
                shadow = false;
                background = false;
              };
            };
            time = lockscreenItem {
              type = "clock";
              cx = 768.0;
              cy = 136.0;
              box_width = 420.0;
              box_height = 124.0; # digits about 9% of the screen height, as on macOS
              settings = {
                format = "{:%H:%M}";
                center_text = true;
                color = "#ffffffd9";
                shadow = false;
                background = false;
              };
            };
            "lockscreen-login-box@eDP-1" = lockscreenItem {
              type = "login_box";
              cx = 768.0;
              cy = 760.0;
              box_width = 400.0; # the compact login box's fixed size
              box_height = 70.0;
              settings = {
                layout = "compact";
                show_session_buttons = false;
                show_media = false;
                show_weather = false;
                show_login_button = false;
                show_keyboard_layout = false;
                show_unlock_hint = false; # macOS has only the field; errors and Caps Lock still show
                background_opacity = 0.0; # no bar around the field, just the field on the wallpaper
                input_opacity = 0.35; # glass
                input_radius = 14.0; # capsule
                center_password_text = true;
              };
            };
          };
        };

        backdrop = {
          # blurred, dimmed wallpaper behind the niri overview, like Mission Control
          enabled = true;
          blur_intensity = 0.6;
          tint_intensity = 0.3;
        };

        # ── Theme & wallpaper ──
        theme = {
          mode = "dark";
          source = "custom";
          custom_palette = "Apple"; # customPalettes.Apple above
        };

        # pick any image in the wallpaper panel (subfolders show up as folders); the choice is
        # kept in noctalia's state, not here. Downloaded manually, not part of the repo.
        wallpaper = {
          directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          transition = [ "fade" ]; # plain crossfade like macOS
          transition_duration = 1000.0;
        };

        # ── Misc ──
        # sunset to sunrise, location from the IP via api.noctalia.dev
        location.auto_locate = true;
        nightlight.enabled = true;

        # ~/.local/share/noctalia/plugins/menubar, see menubar above
        plugins.enabled = [ "yunix/menubar" ];

        # caffeine (no idle lock, screen-off or sleep) is on from the start of every session
        hooks.started = [ "noctalia msg caffeine-enable" ];
      };
    };
  };
}
