{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myUsers.yunix.syncthing;
in {
  options = {
    myUsers.yunix.syncthing = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf (cfg.enable) {
    services = {
      syncthing = {
        enable = true;
        user = "yunix";
        dataDir = "${config.users.users.yunix.home}/Sync";
        configDir = "${config.users.users.yunix.home}/Sync/.config/syncthing";
      };
    };
  };
}
