{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.myModules.desktop;
in {
  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        displayManager = {
          sddm.enable = mkDefault true;
          #defaultSession = "plasmawayland";
        };
      };
    };
  };
}
