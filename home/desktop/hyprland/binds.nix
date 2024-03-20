{
  config,
  osConfig,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.desktop.hyprland;
  osCfg = osConfig.myModules.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";

      bind = [
        "CONTROLALT, Delete, exit,"
        "CONTROLALT, L, exec, hyprlock"
        "$mod, Space, exec, anyrun"
        "$mod, Return, exec, ${osCfg.terminal}"
        "$mod, B, exec, ${osCfg.browser}"
        "$mod, F, fullscreen,"
        "$mod, G, togglegroup,"
        "$mod, J, changegroupactive, f"
        "$mod, K, changegroupactive, b"
        "$mod, T, togglesplit," ## dwindle
        "$mod, M, fullscreen, 1" ## monocle
        "$mod, N, togglefloating,"
        "$mod, P, pseudo," ## dwindle
        "$mod, W, killactive,"
        ## Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        ## Switch workspaces with mainMod + [0-9]
        "$mod, 1, focusworkspaceoncurrentmonitor, 1"
        "$mod, 2, focusworkspaceoncurrentmonitor, 2"
        "$mod, 3, focusworkspaceoncurrentmonitor, 3"
        "$mod, 4, focusworkspaceoncurrentmonitor, 4"
        "$mod, 5, focusworkspaceoncurrentmonitor, 5"
        "$mod, 6, focusworkspaceoncurrentmonitor, 6"
        "$mod, 7, focusworkspaceoncurrentmonitor, 7"
        "$mod, 8, focusworkspaceoncurrentmonitor, 8"
        "$mod, 9, focusworkspaceoncurrentmonitor, 9"
        "$mod, 0, focusworkspaceoncurrentmonitor, 10"
        ## Move active window to a workspace with mainMod + SHIFT
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"
        ## Example special workspace (scratchpad)
        "ALT , S, togglespecialworkspace, magic"
        "ALT_SHIFT, S, movetoworkspace, special:magic"
        ## Scroll through existing workspaces with mainMod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # screenshot
        "$mod SHIFT, S, exec, grimblast --notify --cursor --freeze copysave area"

        ", Print, exec, grimblast --notify --cursor copysave output"

        "$mod, Print, exec, grimblast --notify --cursor copysave screen"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging"
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        # media controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioStop, exec, playerctl stop"

        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      bindle = [
        # volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

        # backlight
        ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
        ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
      ];
    };
  };
}
