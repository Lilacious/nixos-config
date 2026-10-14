{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop;
in
{
  config = mkIf cfg.enable {
    services = {
      # displayManager.defaultSession = "gnome";
      displayManager = {
        enable = true;
        gdm.enable = mkIf (!cfg.plasma.enable) true;
        sddm = {
          enable = mkIf cfg.plasma.enable true;
          wayland.enable = true;
        };
      };
    };
  };
}
