{
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.programs.hyprlock;
  HL = config.myHome.desktop.hyprland;
in {
  options = {
    myHome.programs.hyprlock = {
      enable = mkOption {
        type = types.bool;
        default = HL.enable;
      };
    };
  };
  imports = [inputs.hyprlock.homeManagerModules.default];
  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      backgrounds = [
        {
          monitor = "";
          path = "";
          color = "rgba(30, 30, 46, 1)";
        }
      ];

      input-fields = [
        {
          monitor = "";
          size = {
            width = 320;
            height = 60;
          };
          outline_thickness = 2;
          dots_size = 0.25;
          dots_spacing = 0.25;
          fade_on_empty = false;
          placeholder_text = "<i>Input Password...</i>";
          outer_color = "rgb(245, 194, 231)";
          inner_color = "rgba(37, 40, 60, 1)";
          font_color = "rgb(202, 211, 245)";
          check_color = "rgb(249, 226, 175)";
          fail_color = "rgb(243, 139, 168)";
          fail_text = "<i>$FAIL</i>";
          position = {
            x = 0;
            y = -60;
          };
          halign = "center";
          valign = "center";
        }
      ];

      labels = [
        {
          monitor = "";
          text = "<b>$TIME</b>";
          color = "rgb(202, 211, 245)";
          font_size = 45;
          font_family = "Agave Nerd Font";
          position = {
            x = -12;
            y = 200;
          };
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
