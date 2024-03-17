# For home config see nix-config/home/desktop/plasma.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myModules.desktop;
  catDE = pkgs.callPackage ../../pkgs/catppuccin-kde/package.nix {};
in {
  options = {
    myModules.desktop.plasma = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.plasma.enable {
    myModules.desktop.desktopEnvironment.enable = true;

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
        (catDE.override {
          flavour = ["mocha"];
          accents = ["pink"];
          winDecStyles = ["modern"];
        })
        catppuccin-cursors.mochaPink
        papirus-icon-theme
        xwaylandvideobridge
      ];
    };
  };
}
