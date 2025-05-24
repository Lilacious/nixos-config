# For system config see nix-config/modules/desktop/hyprland.nix
{
  config,
  osConfig,
  lib,
  pkgs,
  options,
  ...
}:
with lib;
let
  cfg = config.myHome.desktop.hyprland;
  osCfg = osConfig.myModules.desktop.hyprland;
  notify = "makoctl dismiss -a && notify-send";
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

  config = mkIf cfg.enable (mkMerge [
    {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          general = {
            border_size = 2;
            gaps_in = 3;
            gaps_out = 6;
            resize_on_border = true;
          };
          decoration = {
            rounding = 10;
          };
          input = {
            kb_layout = "de";
          };
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };
          ecosystem = {
            no_donation_nag = true;
            no_update_news = true;
          };
          "$mod" = "SUPER";
          bind =
            let
              workspaces =
                pref: action: k:
                map (n: "${pref}, ${toString n}, ${action}, ${toString n}") (range 1 k);
            in
            # Switch workspaces with mainMod + [1-9]
            (workspaces "$mod" "focusworkspaceoncurrentmonitor" 9)
            ++ (workspaces "$mod SHIFT" "movetoworkspacesilent" 9)
            ++ [
              "CONTROLALT, Delete, exit,"
              "$mod, Space, exec, fuzzel"
              "$mod, Return, exec, ${osCfg.terminal}"
              "$mod, B, exec, ${osCfg.browser}"
              "$mod, F, fullscreen,"
              "$mod, M, fullscreen, 1" # monocle
              "$mod, T, togglesplit," # dwindle
              "$mod, P, pseudo," # dwindle
              "$mod, V, togglefloating,"
              "$mod, V, centerwindow,"
              "$mod, Q, killactive,"
              # Move focus with mainMod + arrow keys
              "$mod, left, movefocus, l"
              "$mod, right, movefocus, r"
              "$mod, up, movefocus, u"
              "$mod, down, movefocus, d"
              "$mod SHIFT, left, movewindow, l"
              "$mod SHIFT, right, movewindow, r"
              "$mod SHIFT, up, movewindow, u"
              "$mod SHIFT, down, movewindow, d"
            ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging"
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
          bindel =
            let
              volumectl =
                x: # str: i[ncrease]|d[ecrease]
                ''${notify} "Speaker control" "Current volume: ''
                + ''$(pamixer -${x} 5 --unmute --get-volume-human)"'';
              backlight =
                x: # str: volume%+|-
                ''${notify} "Backlight control" "Current brightness: ''
                + ''$(brightnessctl s ${x} -n | grep -oE "[0-9]*%")"'';
            in
            [
              ", XF86AudioRaiseVolume, exec, ${volumectl "i"}"
              ", XF86AudioLowerVolume, exec, ${volumectl "d"}"
              ", XF86MonBrightnessUp, exec, ${backlight "5%+"}"
              ", XF86MonBrightnessDown, exec, ${backlight "5%-"}"
            ];
          bindl =
            let
              mutectl =
                ''${notify} "Speaker control" "Current volume: ''
                + ''$(pamixer --toggle-mute --get-volume-human )"'';
              micMutectl =
                ''${notify} "Microphone control" "Current volume: "''
                + ''$(pamixer --default-source -t --get-volume-human)'';
            in
            [
              ", XF86AudioMute, exec, ${mutectl}"
              ", XF86AudioMicMute, exec, ${micMutectl}"
            ];
          exec-once = [
            "mako"
            "waybar"
          ];
          env = [
            "GDK_BACKEND,wayland,x11,*"
            "QT_QPA_PLATFORM,wayland;xcb"
          ];
        } // osCfg.settings;
      };
      services = {
        hyprpolkitagent.enable = true;
        hyprpaper = {
        enable = true;
        settings = {
          ipc = "on";
          splash = false;
          preload = [
            "~/Pictures/Wallpapers/KDEScarlettTreeDark.png"
          ];
          wallpaper = [
            ", ~/Pictures/Wallpapers/KDEScarlettTreeDark.png"
          ];
        };
        };
      };

      home.packages = with pkgs; [
        brightnessctl
        pamixer
      ];

      myHome = {
        programs = {
          waybar.enable = true;
          # laucher
          fuzzel.enable = true;
        };
        services = {
          mako.enable = true;
        };
      };
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          stylix.targets.hyprland.enable = true;
        }
      else
        { }
    )
  ]);
}
