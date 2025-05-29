{
  osConfig,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myHome.services.syncthing;
  homeDir = config.home.homeDirectory;
  osCfg = osConfig.myModules.services.syncthing;
in
{
  options = {
    myHome.services.syncthing = {
      enable = mkEnableOption "syncthing";
    };
  };
  imports = [
    (mkAliasOptionModule
      [
        "myHome"
        "services"
        "syncthing"
        "settings"
      ]
      [
        "services"
        "syncthing"
        "settings"
      ]
    )
  ];
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      settings = {
        folders = {
          "KeePassXC" = {
            # Name of folder in Syncthing, also the folder ID
            path = "${homeDir}/Sync/KeePassXC"; # Which folder to add to Syncthing
            versioning = {
              type = "simple";
              params.keep = "250";
            };
            # Which devices to share the folder with
            devices = [
              "Hades"
              "Hestia"
              "Hypnos"
              "Kalypso"
              "Leto"
              "Orupi"
              "Penelope"
            ];
          };
        };
      } // osCfg.settings;
      # configDir options does not exist in hm, default path is:
      # configDir =
      #   if pkgs.stdenv.isDarwin then
      #     "~/Library/Application Support/Syncthing"
      #   else
      #     "~/.local/state/syncthing";
    };
  };
}
