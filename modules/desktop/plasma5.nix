{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.myModules.desktop.plasma5;
in
{
  imports = [
    ./plasma-config.nix
  ];
  options = {
    myModules.desktop.plasma5 = {
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
          defaultSession = "plasmawayland";
        };
        desktopManager.plasma5.enable = true;
      };
    };

    environment = {
      plasma5.excludePackages = with pkgs.libsForQt5; [
        elisa
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
      ];
    };
  };
}
