{ lib, pkgs, config, ... }:
with lib;
let
  homecfg = config.home-manager.users.${config.variables.username};
  cfg = config.myModules.desktop;
in
{
  config = mkIf cfg.enable {
    home-manager.users.${config.variables.username} = {
      home.pointerCursor = {
        package = pkgs.catppuccin-cursors.mochaPink;
        name = "Catppuccin-Mocha-Pink-Cursors";
        size = 16;
        gtk.enable = true;
      };

      gtk = {
        enable = true;
        gtk2.configLocation = "${homecfg.xdg.configHome}/gtk-2.0/gtkrc";
        theme = {
          name = "Catppuccin-Mocha-Compact-Pink-Dark";
          package = pkgs.catppuccin-gtk.override {
            accents = [ "pink" ];
            size = "compact";
            variant = "mocha";
          };
        };
      };
    };
  };
}
