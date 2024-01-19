{ config, lib, variables, ... }:

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
        user = "${variables.username}";
        dataDir = "/home/${variables.username}/Sync";
        configDir = "/home/${variables.username}/Sync/.config/syncthing";        
      };
    };
  };
}
