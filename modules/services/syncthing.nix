{ config, lib, ... }:

with lib;
let
  cfg = config.myModules.services.syncthing;
in
{
  options = {
    myModules.services.syncthing = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (cfg.enable) {
    services = {
      syncthing = {
        enable = true;
        user = "${config.variables.username}";
        dataDir = "/home/${config.variables.username}/Sync";
        configDir = "/home/${config.variables.username}/Sync/.config/syncthing";        
      };
    };
  };
}
