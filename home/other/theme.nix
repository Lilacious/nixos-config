{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.myHome.other.theme;
  dsktp = config.myHome.desktop;
in {
  options = {
    myHome.other.theme = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf (cfg.enable && dsktp.enable) {
    home.pointerCursor = {
      package = pkgs.catppuccin-cursors.mochaPink;
      name = "Catppuccin-Mocha-Pink-Cursors";
      size = 16;
      gtk.enable = true;
    };

    gtk = {
      enable = true;
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      theme = {
        name = "Catppuccin-Mocha-Compact-Pink-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["pink"];
          size = "compact";
          variant = "mocha";
        };
      };
    };
  };
}
