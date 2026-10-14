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
        # plasma > cosmic > gnome/others
        gdm.enable = mkIf (!cfg.plasma.enable && !cfg.cosmic.enable) true;
        cosmic-greeter.enable = mkIf (cfg.cosmic.enable && !cfg.plasma.enable) true;
        sddm = {
          enable = mkIf cfg.plasma.enable true;
          wayland.enable = true;
        };
      };
    };
  };
}
