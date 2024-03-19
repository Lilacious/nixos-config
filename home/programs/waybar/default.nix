{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.programs.waybar;
  WM = config.myHome.desktop.windowManager;
in {
  options = {
    myHome.programs.waybar = {
      enable = mkOption {
        type = types.bool;
        default = WM.wayland;
      };
    };
  };

  imports = [
    ./settings.nix
  ];

  config = mkIf cfg.enable {
    programs = {
      waybar = {
        enable = true;
        style = ./style.css;
      };
    };

    home.packages = with pkgs; [
      libappindicator
    ];
  };
}
