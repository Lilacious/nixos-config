{ config, ... }:
let
  cfg = config.myModules.services.syncthing;
in
{
  myModules.services.syncthing = {
    user = "yunix";
    settings = {
      devices = {
        "Deimos" = {
          id = "A7SU6SK-O26XB2T-AAYSEFT-2ZDKBBB-6MXUPIW-DHXLEPX-CQI32CZ-VAKJOQT";
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
          id = "4GFNPVP-VTSQ4TR-UJH7634-KR6HVXY-6W4LBF3-C2RG2NU-XA2WT6G-U5DV7Q4";
        };
        "LetoII" = {
          id = "IOT32FW-RQK52RO-MM3HWWN-RLGC6DH-MMMMZO2-G4AAEBY-ATWNNW4-GJKZKA5";
        };
        "Penelope" = {
          id = "TDAPHUQ-CXVBYJI-GIRIZTC-B3F7JNC-7DK7QTP-JX4AVB6-AER7FXE-SZLI6AX";
        };
      };
      folders = {
        "KeePassXC" = {
          # Name of folder in Syncthing, also the folder ID
          path = "/home/${cfg.user}/Sync/KeePassXC"; # Which folder to add to Syncthing
          versioning = {
            type = "simple";
            params.keep = "250";
          };
          # Which devices to share the folder with
          devices = [
            "Deimos"
            "Hestia"
            "Hypnos"
            "Kalypso"
            "Leto"
            "LetoII"
            "Penelope"
          ];
        };
      };
    };
  };
}
