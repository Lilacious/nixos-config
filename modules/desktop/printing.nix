{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop.services.printing;
in
{
  options = {
    myModules.desktop.services.printing = {
      enable = mkEnableOption "printing service";
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
