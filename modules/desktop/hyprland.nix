{ config, lib, pkgs, variables, inputs, ... }:
with lib;
let
  cfg = config.myModules.desktop.hyprland;
in
{
  options = {
    myModules.desktop.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (cfg.enable) {
    programs.hyprland.enable = true;
    
    home-manager.users.${variables.username} = {
      wayland.windowManager.hyprland = {
        enable = true;
      };
    };
  };
}
