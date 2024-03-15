{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.myModules;
in {
  config = mkIf cfg {
    ## Default time zone
    time.timeZone = mkDefault "Europe/Berlin";
    programs.dconf.enable = mkDefault true;
    hardware.enableRedistributableFirmware = mkDefault true;
    nixpkgs.config.allowUnfree = mkDefault true;
  };
}
