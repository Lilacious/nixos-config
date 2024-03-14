{ config, lib, ... }:
with lib;
let
  cfg = config.myModules.desktop.hyprland;
in
{
  options = {
    myModules.desktop.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      terminal = mkOption {
        type = types.str;
        default = "alacritty";
      };

      browser = mkOption {
        type = types.str;
        default = "firefox";
      };

      settings = mkOption {
        type = with lib.types;
          let
            valueType = nullOr (oneOf [
              bool
              int
              float
              str
              path
              (attrsOf valueType)
              (listOf valueType)
            ]) // {
              description = "Hyprland configuration value";
            };
          in valueType;
        default = { 
          monitor = [
            ",preferred,auto,auto"
          ];
        };
      };
    };
  };

  config = mkIf (cfg.enable) {
    programs.hyprland.enable = true;
    
    home-manager.users.${config.variables.username} = {
      wayland.windowManager.hyprland = {
        enable = true;

        settings = {
          general = {
            border_size = 2;
            ## Gaps between windows
            gaps_in = 2.5;
            ## Gaps between windows and monitor edges
            gaps_out = 5;
            ## Border color
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";
            ## Layout to use. [dwindle/master]
            layout = "dwindle";
          };

          decoration = {
            ## Rounded corner radius
            rounding = 10;
            ## Opacity
            active_opacity = 0.95;
            inactive_opacity = 0.95;
            fullscreen_opacity = 1.0;
            ## Shadows
            drop_shadow = true;
            shadow_range = 4;
            shadow_render_power = 3;
            "col.shadow" = "rgba(1a1a1aee)";
            ## Blur
            blur = {
              enabled = true;
              size = 8;
              passes = 1;
            };
          };

          animations = {
            enabled = true;
            bezier = [
              "eoexp, 0.16, 1, 0.3, 1"
            ];

            animation = [
              "windows, 1, 7, eoexp"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          input = {
            kb_layout = "de";
          };

          dwindle = {
            preserve_split = true;
          };

          windowrulev2 = [
            "suppressevent maximize, class:.*"
          ];

          "$mod" = "SUPER";

          bind = [
            "CONTROLALT, Delete, exit,"
            "$mod, Return, exec, ${cfg.terminal}"
            "$mod, B, exec, ${cfg.browser}"
            "$mod, W, killactive,"
            "$mod, M, fullscreen, 1" ## monocle
            "$mod, F, togglefloating,"
            "$mod, P, pseudo," ## dwindle
            "$mod, J, togglesplit," ## dwindle
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
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"
            "$mod SHIFT, 0, movetoworkspace, 10"
            ## Example special workspace (scratchpad)
            "$mod, S, togglespecialworkspace, magic"
            "$mod SHIFT, S, movetoworkspace, special:magic"
            ## Scroll through existing workspaces with mainMod + scroll
            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"
          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging"
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
        } // cfg.settings;
      };
    };
  };
}
