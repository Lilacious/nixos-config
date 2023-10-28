{ config, lib, ... }:

with lib;
{
  options = {
    printing = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.printing.enable) {
    ## Printer with avahi
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns = true;
    ## For a WiFi printer
    services.avahi.openFirewall = mkDefault true;
  };
}
