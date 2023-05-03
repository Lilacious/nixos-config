{ pkgs, config, lib, ... }:
{
  programs.waybar = {
    enable = true;

    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }); 

    settings = {

      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "eDP-1"
          "HDMI-A-1"
          "HDMI-A-2"

        ];
        modules-left = [ "wlr/workspaces" ];
        modules-center = [  ];
        modules-right = [  ];

        "wlr/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
          "on-click" = "activate";
          "persistent_workspaces" = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
            "7" = [];
            "8" = [];
            "9" = [];
            "10" = [];
          };
        };
      };
     
    };
    style = builtins.readFile ./waybar.css;
  };
}
