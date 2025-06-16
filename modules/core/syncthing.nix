# Use the NixOS module for servers and the home-manager module for
# graphical systems and darwin
{
  config,
  lib,
  pkgs,
  options,
  ...
}:
with lib;
let
  cfg = config.myModules.services.syncthing;
  inherit (cfg) user;
  settingsFormat = pkgs.formats.json { };
in
{
  options = {
    myModules.services.syncthing = {
      enable = mkEnableOption "syncthing for one user";
      user = mkOption {
        type = types.str;
        default = "";
      };
      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
        };
        default = {};
      };
    };
  };
  config = mkMerge [
    {
      assertions = [
        {
          assertion = cfg.settings != {} -> cfg.user != "";
          message = ''
            myModules.services.syncthing.user must be set to an active user if
            myModules.services.syncthing.settings is not empty.
          '';
        }
      ];
    }
    (
      if (builtins.hasAttr "syncthing" options.services) then
        (mkIf cfg.enable {
          services = {
            syncthing = {
              enable = true;
              inherit (cfg) settings;
              inherit user;
              group = "users";
              dataDir = "/home/${user}/Sync"; # Default folder for new synced folders
              configDir = "/home/${user}/.local/state/syncthing"; # Folder for Syncthing's settings and keys
            };
          };
        })
      else
        { }
    )
  ];
}
