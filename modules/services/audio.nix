{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myModules.services.audio;
in
{
  options = {
    myModules.services.audio = {
      enable = mkEnableOption "audio settings";
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
