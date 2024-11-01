{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop;
in
{
  options = {
    myModules.desktop.plasma = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.plasma.enable {
    myModules = {
      desktop.desktopEnvironment.enable = true;
      other.inputMethod.qt = mkDefault true;
    };

    services.desktopManager.plasma6.enable = true;

    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
        kate
        khelpcenter
        okular
        oxygen
        plasma-browser-integration
      ];
      systemPackages = with pkgs; [
        (catppuccin-kde.override {
          flavour = [ "mocha" ];
          accents = [ "pink" ];
          winDecStyles = [ "modern" ];
        })
        catppuccin-cursors.mochaPink
        papirus-icon-theme
        #xwaylandvideobridge
      ];
    };
  };
}
