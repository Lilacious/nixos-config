{ config, lib, variables, pkgs, ... }:

with lib;
let
  cfg = config.myModules.services.corectrl;
in {
  options = {
    myModules.services.corectrl = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (cfg.enable) {
    programs.corectrl.enable = true;
    users.users.${variables.username}.extraGroups = [ "corectrl" ];

    systemd.user.services.corectrl-systray = {
      enable = true;
      path = [ pkgs.corectrl ];
      script = ''
        corectrl --minimize-systray
      '';
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
    };
  };
}
