{
  osConfig,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myHome.services.syncthing;
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
      inherit (osCfg) settings;
      # configDir options does not exist in hm, default path is:
      # configDir =
      #   if pkgs.stdenv.isDarwin then
      #     "~/Library/Application Support/Syncthing"
      #   else
      #     "~/.local/state/syncthing";
    };
  };
}
