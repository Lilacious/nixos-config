{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.services.playerctl;
  HL = config.myHome.desktop.hyprland;
in {
  options = {
    myHome.services.playerctl = {
      enable = mkOption {
        type = types.bool;
        default = HL.enable;
      };
    };
  };
  config = mkIf cfg.enable {
    services.playerctld.enable = true;
    home.packages = with pkgs; [playerctl];
  };
}
