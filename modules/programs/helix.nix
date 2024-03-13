{ config, lib, variables, ... }:

with lib;
let
  cfg = config.myModules.programs.helix;
in {
  options = {
    myModules.programs.helix = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (cfg.enable) {
    home-manager.users.${variables.username} = {
      programs.helix = {
        enable = true;
      };
    };
  };
}
