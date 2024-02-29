{ config, lib, pkgs, variables, inputs, ... }:
with lib;
let
  cfg = config.myModules.desktop.plasma;
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

  config = mkIf (cfg.enable) {
    services = {
      xserver = {
        enable = true;
        displayManager = {
          sddm.enable = mkDefault true;
          #defaultSession = "plasmawayland";
        };
        desktopManager.plasma6.enable = true;
      };
    };

    environment = {
      plasma6.excludePackages = with pkgs.libsForQt5; [
        elisa
        plasma-browser-integration
        #khelpcenter
        konsole
        oxygen
      ];
      systemPackages = with pkgs; [
        (catppuccin-kde.override {
          flavour = [ "mocha" ];
          accents = [ "pink" ];
          winDecStyles = [ "modern" ];
        })
        catppuccin-cursors.mochaPink
        papirus-icon-theme
        xwaylandvideobridge
      ];
    };

    home-manager.users.${variables.username} = {
      imports = [
        inputs.plasma-manager.homeManagerModules.plasma-manager
        ./plasma-config.nix
      ];
    };
  };
}
