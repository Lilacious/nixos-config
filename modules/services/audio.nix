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
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    ## Printer with avahi
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
    ## For a WiFi printer
    services.avahi.openFirewall = mkDefault true;
  };
}
