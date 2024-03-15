{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.myModules;
in {
  config = mkIf cfg {
    networking.firewall.enable = mkForce true;
    time.timeZone = mkDefault "Europe/Berlin";
    #programs.dconf.enable = mkDefault true;
    hardware.enableRedistributableFirmware = mkDefault true;
    nixpkgs.config.allowUnfree = mkDefault true;
  };
}
