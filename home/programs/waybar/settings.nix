{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.programs.waybar;
in {
  config = mkIf cfg.enable {
    programs.waybar.settings = [
      {
        name = "main";
        layer = "top";
        position = "top";
        margin = "6px 6px 0px 6px";
        modules-left = [
          "group/power-opt"
          "hyprland/workspaces"
          "custom/separator-left"
          "hyprland/window"
        ];
        modules-center = [];
        modules-right = [
          "group/stats"
          "custom/separator-right"
          "group/utils"
          "custom/separator-right"
          "tray"
          "clock"
        ];

        ##TODO disable after configuring
        reload_style_on_change = true;

        # Modules
        clock = {
          format = "{:%a, %d.%m.%y \n    %R }";
        };

        network = {
          "format-wifi" = "  {essid}";
          "format-ethernet" = "󰈀  Connected";
          "tooltip-format" = "{ifname} via {gwaddr}";
          "format-linked" = "{ifname} (No IP)";
          "format-disconnected" = " Disconnected";
        };

        cpu = {
          format = "  {usage}%";
        };

        memory = {
          format = "  {percentage}%";
        };

        temperature = {
          format = " {temperatureC}°C";
        };

        tray = {
          icon-size = 20;
          spacing = 10;
        };

        pulseaudio = {
          scroll-step = 1;
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          on-click = "pavucontrol";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = " {capacity}%";
          format-discharging = "{icon} {capacity}%";
          format-icons = [
            "󰂃"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        # Hyprland
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "1" = "󰆍 ";
            "2" = " ";
            "3" = " ";
            "4" = " ";
            "5" = " ";
            "6" = "󰆍 ";
            "7" = ";";
            "8" = " ";
            "9" = " ";
            "10" = " ";
            "default" = "";
          };
          "persistent-workspaces" = {
            "*" = 5;
          };
        };

        "hyprland/window" = {
          "format" = "{title} ~";
        };

        # Custom modules
        "custom/nix" = {
          "format" = "";
          "tooltip" = false;
        };

        "custom/separator-right" = {
          "format" = "";
          "tooltip" = false;
        };

        "custom/separator-left" = {
          "format" = "";
          "tooltip" = false;
        };

        "custom/quit" = {
          "format" = "󰗼";
          "tooltip" = false;
          "on-click" = "hyprctl dispatch exit";
        };

        "custom/lock" = {
          "format" = "󰍁";
          "tooltip" = false;
          "on-click" = "swaylock";
        };

        "custom/reboot" = {
          "format" = "󰜉";
          "tooltip" = false;
          "on-click" = "reboot";
        };

        "custom/power" = {
          "format" = "";
          "tooltip" = false;
          "on-click" = "shutdown now";
        };

        # Groups
        "group/stats" = {
          "orientation" = "inherit";
          "modules" = [
            "network"
            "cpu"
            "memory"
            "temperature"
            "backlight"
            "battery"
          ];
        };

        "group/utils" = {
          "orientation" = "inherit";
          "modules" = [
            "pulseaudio"
          ];
        };

        "group/power-opt" = {
          "orientation" = "inherit";
          "drawer" = {
            "transition-duration" = 500;
            "children-class" = "not-power";
            "transition-left-to-right" = true;
          };
          "modules" = [
            "custom/nix"
            "custom/power"
            "custom/quit"
            "custom/lock"
            "custom/reboot"
          ];
        };
      }
    ];
  };
}
