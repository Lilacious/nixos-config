{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.services.mako;
  HL = config.myHome.desktop.hyprland;
in {
  options = {
    myHome.services.mako = {
      enable = mkOption {
        type = types.bool;
        default = HL.enable;
      };
    };
  };
  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      defaultTimeout = 3000;

      font = "Agave Nerd Font 12";

      borderSize = 2;
      borderRadius = 10;
      borderColor = "#f5c2e7";
      backgroundColor = "#25283c";

      height = 200;
      width = 325;

      anchor = "bottom-right";
      margin = "75,75";
    };

    home.packages = with pkgs; [libnotify];
  };
}
