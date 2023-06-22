{ pkgs, ... }:
{
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaPink;
    name = "Catppuccin-Mocha-Pink-Cursors";
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };
  gtk = {
    enable = false;
    font = {
      name = "Agave Nerd Font";
      size = 13;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        variant = "mocha";
      };
    };
  };
}
