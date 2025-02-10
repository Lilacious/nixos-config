{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.myHome.desktop.theme;
  dsktp = config.myHome.desktop;
in
{
  options = {
    myHome.desktop.theme = {
      enable = mkOption {
        type = types.bool;
        default = dsktp.enable;
      };
    };
  };

  config = mkIf cfg.enable {
    home.pointerCursor = {
      package = pkgs.whitesur-cursors;
      name = "WhiteSur-cursors";
      size = 20;
      gtk.enable = true;
    };

    gtk = {
      enable = true;
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

      theme = {
        name = "catppuccin-mocha-mauve-compact";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          variant = "mocha";
          size = "compact";
        };
      };

      iconTheme = {
        name = "WhiteSur";
        # Build failure due to broken symlinks
        # https://github.com/NixOS/nixpkgs/issues/380279
        package = pkgs.whitesur-icon-theme.overrideAttrs {
          dontCheckForBrokenSymlinks = true;
        };
      };
    };
  };
}
