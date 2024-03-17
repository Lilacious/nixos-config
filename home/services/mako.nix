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

      font = "Agave Nerd Font 14";

      borderSize = 1;
      borderRadius = 10;
      borderColor = "#f38ba8";
      backgroundColor = "#1e1e2e";

      anchor = "bottom-right";
      margin = "10,25,5";
    };

    home.packages = with pkgs; [libnotify];
  };
}
