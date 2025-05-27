{
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.waybar;
  batteryAttrs = {
    states = {
      warning = 30;
      critical = 15;
    };
    format = "  {capacity}%";
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
in
{
  options = {
    myHome.programs.waybar = {
      enable = mkEnableOption "waybar";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ pavucontrol ];
      programs.waybar = {
        enable = true;
        settings = [
          {
            reload_style_on_change = true;
            name = "main";
            layer = "top";
            position = "top";
            margin = "6px 6px 0px 6px";
            modules-left = [
              "hyprland/workspaces"
            ];
            modules-center = [
              "hyprland/window"
            ];
            modules-right = [
              "tray"
              "group/utils"
              "clock"
            ];
            # Groups
            "group/utils" = {
              orientation = "inherit";
              modules = [
                "network"
                "cpu"
                "memory"
                "backlight"
                "pulseaudio"
                "group/batteries"
                "power-profiles-daemon"
              ];
            };
            "group/batteries" = {
              orientation = "inherit";
              modules = [
                "battery"
                "battery#0"
                "battery#1"
              ];
              drawer = {
                click-to-reveal = true;
              };
            };
            # Hyprland
            "hyprland/workspaces" = {
              format = "{icon}";
              format-icons = {
                "1" = "󰆍 ";
                "2" = " ";
                "3" = " ";
                "4" = " ";
                "5" = " ";
                "6" = "󰆍 ";
                "7" = " ";
                "8" = " ";
                "9" = " ";
                "default" = " ";
              };
              persistent-workspaces = {
                "*" = 9;
              };
            };
            "hyprland/window" = {
              format = "{title} ~";
            };
            clock = {
              format = "{:%a, %d.%m.%y \n    %R }";
              tooltip = false;
            };
            network = {
              format-wifi = "  {essid}";
              format-ethernet = "󰈀  Connected";
              tooltip-format = "{ifname} via {gwaddr}";
              format-linked = "{ifname} (No IP)";
              format-disconnected = " Disconnected";
            };

            cpu = {
              format = "  {usage}%";
            };

            memory = {
              format = "  {percentage}%";
              tooltip-format = "{used:0.1f}GiB/{total:0.1f}GiB used";
            };

            tray = {
              icon-size = 20;
              spacing = 10;
            };

            pulseaudio = {
              scroll-step = 1;
              format = "{icon} {volume}%";
              format-bluetooth = "{icon} {volume}% ";
              format-muted = "󰖁 ";
              format-icons = {
                headphone = "";
                hand-sfree = "";
                headset = "󰋎";
                phone = "";
                portable = "";
                car = "";
                default = [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                ];
              };
              on-click = "pavucontrol";
            };
            battery = {
              weighted-average = true;
            } // batteryAttrs;
            "battery#0" = {
              bat = "BAT0";
            } // batteryAttrs;
            "battery#1" = {
              bat = "BAT1";
            } // batteryAttrs;
            backlight = {
              format = "  {percent}%";
            };
            power-profiles-daemon = {
              format = "{icon} {profile}";
              format-icons = {
                default = "";
                performance = "";
                balanced = "";
                power-saver = "";
              };
            };
          }
        ];
        style = ''
          window#waybar {
              background: @base00;
              border: 2px solid @base03;
              border-radius: 10px;
              color: @base05;
          }
          window#waybar.hidden {
              opacity: 0.2;
          }
          tooltip {
              background: @base00;
              border: 2px solid @base08;
          }
          tooltip label {
              color: @base05;
              font-weight: bold;
          }
          button {
              /* Use box-shadow instead of border so the text isn't offset */
              box-shadow: inset 0 -2px transparent, inset 0 2px transparent;
              /* Avoid rounded borders under each button name */
              border: none;
              border-radius: 0;
          }
          button:hover {
              background: inherit;
              box-shadow: inset 0 -2px @base0D, inset 0 2px @base0D;
          }
          #workspaces {
              padding: 0 10px;
          }
          #workspaces label {
              font-size: 19px;
          }
          #workspaces button.empty {
              color: @base03;
          }
          #workspaces button.visible {
              color: @base0D;
          }
          #workspaces button.active {
              color: @base0B;
          }
          #workspaces button.urgent {
              color: @base08;
          }
          #window label {
              font-size: 15px;
          }
          #clock {
              font-size: 14px;
              font-weight: bold;
              margin: 2px 10px 0;
              padding: 3px 0;
          }
          #network,
          #cpu,
          #memory,
          #disk,
          #temperature,
          #battery,
          #backlight,
          #power-profiles-daemon,
          #pulseaudio {
              font-weight: bold;
              font-size: 14px;
              padding: 2px 8px 0;
              color: @base0E;
          }
          #tray {
              padding: 0 10px;
          }
          box#utils {
              padding: 0 10px;
          }
        '';
      };
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          stylix.targets.waybar = {
            enable = true;
            addCss = false;
            font = "serif";
          };
        }
      else
        {
          programs.waybar.style = ''
            @define-color base00 #232136;
            @define-color base01 #2a273f;
            @define-color base02 #393552;
            @define-color base03 #6e6a86;
            @define-color base04 #908caa;
            @define-color base05 #e0def4;
            @define-color base06 #f5e0dc;
            @define-color base07 #56526e;
            @define-color base08 #f38ba8;
            @define-color base09 #fab387;
            @define-color base0A #f9e2af;
            @define-color base0B #a6e3a1;
            @define-color base0C #94e2d5;
            @define-color base0D #89b4fa;
            @define-color base0E #cba6f7;
            @define-color base0F #f2cdcd;
            * {
                font-family: "Agave Nerd Font";
                font-size: 10pt;
            }
          '';
        }
    )
  ]);
}
