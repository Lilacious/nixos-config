# For home config see nix-config/home/desktop/plasma.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myModules.desktop.plasma;
in {
  options = {
    myModules.desktop.plasma = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (cfg.enable) {
    cfg.displayManager.enable = mkForce true;

    services.desktopManager.plasma6.enable = true;

    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
        plasma-browser-integration
        khelpcenter
        konsole
        oxygen
      ];
      systemPackages = with pkgs; [
        (catppuccin-kde.override {
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
