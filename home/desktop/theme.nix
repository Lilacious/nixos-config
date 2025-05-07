{
  lib,
  pkgs,
  config,
  options,
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

  config = mkIf cfg.enable (mkMerge [
    {
      home.pointerCursor = {
        package = pkgs.whitesur-cursors;
        name = "WhiteSur-cursors";
        size = 20;
        gtk.enable = true;
      };

      gtk = {
        enable = true;
        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

        iconTheme = {
          name = "WhiteSur";
          package = pkgs.whitesur-icon-theme;
        };
      };
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          stylix.targets.gtk = {
            enable = true;
            flatpakSupport.enable = true;
          };
        }
      else
        {
          gtk.theme = {
            name = "catppuccin-mocha-mauve-compact";
            package = pkgs.catppuccin-gtk.override {
              accents = [ "mauve" ];
              variant = "mocha";
              size = "compact";
            };
          };
        }
    )
  ]);
}
