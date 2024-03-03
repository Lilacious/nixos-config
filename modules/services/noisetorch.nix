{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myModules.services.noisetorch;
in {
  options = {
    myModules.services.noisetorch = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      deviceId = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Device ID of the source device to load.
          If no source device ID is specified, the default
          audio source is used.

          To list available devices and ID use "noisetorch -l"
        '';
      };
    };
  };
  config = mkIf (cfg.enable) {
    programs.noisetorch.enable = true;

    systemd.user.services.noisetorch-autoload = {
      enable = true;
      path = [ pkgs.noisetorch ];
      script = ''
        noisetorch -i ${config.myModules.services.noisetorch.deviceId}
      '';
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
    };
  };
}
