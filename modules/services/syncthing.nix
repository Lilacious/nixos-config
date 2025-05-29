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
      enable = mkEnableOption "syncthing";
      user = mkOption {
        type = types.str;
        default = "yunix";
      };
      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
        };
      };
    };
  };
  config = mkMerge [
    {
      myModules.services.syncthing.settings = {
        devices = {
          "Hades" = {
            id = "I7SODCH-2VBY2CC-K466KOQ-W3RVO7R-Z2GJZHH-6WRYKP3-SJFJ4DZ-YD5R5AP";
          };
          "Hestia" = {
            id = "HQCTYWV-HQ67DDS-V5SVNS7-EMI2QBC-WJ6TZXM-EOAXOGQ-X3X5J4G-F46MCAF";
          };
          "Hypnos" = {
            id = "DDLFRKN-QGMRSJS-3G26GZG-7AHVC76-HALBQBW-HVBE775-BBRTNAK-WWCUIAD";
          };
          "Kalypso" = {
            id = "YCGZIQO-TIJG44Y-LXXAUW5-5U3VWIB-WROJHBQ-MEMVSJX-YO2NIWW-D3ODVAC";
          };
          "Leto" = {
            id = "2B3AZKJ-C5IHVCO-EWSJU3K-RCCHTTM-BPL6K4M-FPSSNIY-IIKOGBI-TWGDZAT";
          };
          "Orupi" = {
            id = "U6WKHF6-K4MQL4M-MKDBJJW-FTGZZIN-7OLUJGQ-VCUGH7D-2GCHOGB-7SJKNQY";
          };
          "Penelope" = {
            id = "TDAPHUQ-CXVBYJI-GIRIZTC-B3F7JNC-7DK7QTP-JX4AVB6-AER7FXE-SZLI6AX";
          };
        };
      };
    }
    (
      if (builtins.hasAttr "syncthing" options.services) then
        (mkIf cfg.enable {
          services = {
            syncthing = {
              enable = true;
              settings = {
                folders = {
                  "KeePassXC" = {
                    # Name of folder in Syncthing, also the folder ID
                    path = "/home/${user}/Sync/KeePassXC"; # Which folder to add to Syncthing
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
              } // cfg.settings;
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
