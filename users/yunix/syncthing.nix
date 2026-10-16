{ config, lib, ... }:
with lib;
let
  cfg = config.myModules.services.syncthing;
  # Only create a folder on hosts that are in its device list
  onThisHost = devices: elem (toLower (toString config.networking.hostName)) (map toLower devices);
in
{
  myModules.services.syncthing = {
    user = "yunix";
    settings = {
      options.urAccepted = -1; # disable usage reporting
      devices = {
        "Deimos" = {
          id = "IMP6ZI2-3366P5J-G4XTOV6-6SNN6BY-C3NGC6P-B2BICSE-2BHMQWI-ZUQ7GQ5";
        };
        "Hestia" = {
          id = "HQCTYWV-HQ67DDS-V5SVNS7-EMI2QBC-WJ6TZXM-EOAXOGQ-X3X5J4G-F46MCAF";
        };
        "Hypnos" = {
          id = "SNWOP37-KZ6NCUO-3SQULCV-UU6T6KP-33T3VJL-EF52VAF-EK5JMUT-LU3G4AR";
        };
        "Leto" = {
          id = "4GFNPVP-VTSQ4TR-UJH7634-KR6HVXY-6W4LBF3-C2RG2NU-XA2WT6G-U5DV7Q4";
        };
        "LetoII" = {
          id = "IOT32FW-RQK52RO-MM3HWWN-RLGC6DH-MMMMZO2-G4AAEBY-ATWNNW4-GJKZKA5";
        };
        "Orupi" = {
          id = "U6WKHF6-K4MQL4M-MKDBJJW-FTGZZIN-7OLUJGQ-VCUGH7D-2GCHOGB-7SJKNQY";
        };
        "Penelope" = {
          id = "TDAPHUQ-CXVBYJI-GIRIZTC-B3F7JNC-7DK7QTP-JX4AVB6-AER7FXE-SZLI6AX";
        };
        "Quartz" = {
          id = "2ZTNTMV-W3HXIVU-PGQRHUH-FSLJBC4-DUXTYBB-ERE6NCA-ZDPTJG4-4B7GGQ7";
        };
      };
      folders = {
        "KeePassXC" = {
          # Name of folder in Syncthing, also the folder ID
          path = "${config.users.users.${cfg.user}.home}/Sync/KeePassXC"; # Which folder to add to Syncthing
          versioning = {
            type = "simple";
            params.keep = "250";
          };
          fsWatcherDelayS = 1; # send saves quickly to shrink the conflict window
          # Which devices to share the folder with
          devices = [
            "Deimos"
            "Hestia"
            "Hypnos"
            "Leto"
            "LetoII"
            "Orupi"
            "Penelope"
            "Quartz"
          ];
        };
        "Obsidian" = rec {
          path = "${config.users.users.${cfg.user}.home}/Sync/Obsidian";
          versioning = {
            type = "staggered";
            params.maxAge = toString (90 * 24 * 60 * 60); # 90 days, in seconds
          };
          ignorePatterns = [
            ".obsidian/workspace.json"
            ".obsidian/workspace-mobile.json"
            ".trash"
          ];
          devices = [
            "Deimos"
            "Hestia"
            "Penelope"
          ];
          enable = onThisHost devices;
        };
      };
    };
  };
}
