{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings =
      {
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
          active_opacity = 0.99;
          inactive_opacity = 0.98;
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

        misc = {
          disable_splash_rendering = true;
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
      }
      // cfg.settings;
  };
}
