{
  lib,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfg = config.myHome.desktop;
  osCfg = osConfig.myModules.desktop;
in
{
  options = {
    myHome.desktop = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
      };
    };
  };

  imports = [
    ./gnome.nix
    ./hyprland.nix
    #./niri.nix
    ./plasma.nix
    ./theme.nix
  ];

  config = mkIf cfg.enable {
    myHome = {
      programs = {
        alacritty.enable = true;
        ghostty.enable = true;
        direnv.enable = true;
        zathura.enable = true;
      };
      # Use the home-manager module on graphical systems
      services.syncthing.enable = true;
    };
  };
}
