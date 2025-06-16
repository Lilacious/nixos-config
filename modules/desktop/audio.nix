{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop.services.audio;
in
{
  options = {
    myModules.desktop.services.audio = {
      enable = mkEnableOption "audio settings" // {
        default = config.myModules.desktop.enable;
      };
    };
  };
  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
  };
}
