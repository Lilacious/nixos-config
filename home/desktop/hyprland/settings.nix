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
    wayland.windowManager.hyprland.settings =
      {
        general = {
          border_size = 2;
          ## Gaps between windows
          gaps_in = 3;
          ## Gaps between windows and monitor edges
          gaps_out = 6;
          ## Border color
          "col.active_border" = "rgba(f5c2e7aa) rgba(a6e3a1aa) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          ## Layout to use. [dwindle/master]
          layout = "dwindle";
        };

        decoration = {
          ## Rounded corner radius
          rounding = 10;
          ## Opacity
          active_opacity = 1.0;
          inactive_opacity = 1.0;
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

        group = {
          groupbar = {
            font_family = "Agave Nerd Font";
            font_size = 10;
            "col.active" = "rgba(1e1e2eee)";
            "col.inactive" = "rgba(373a50ee)";
            text_color = "rgba(cba6f7ff)";
          };
          "col.border_active" = "rgba(1e1e2eee)";
          "col.border_inactive" = "rgba(373a50ee)";
        };

        input = {
          kb_layout = "de";
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        windowrulev2 = [
          "suppressevent maximize, class:.*"
        ];
      }
      // osCfg.settings;
  };
}
