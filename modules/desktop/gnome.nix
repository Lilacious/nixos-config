# For home config see nix-config/home/desktop/gnome.nix
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
    myModules.desktop.gnome = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.gnome.enable {
    myModules.other.inputMethod.enable = mkDefault true;

    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      gnome-contacts
      gnome-initial-setup
      gnome-maps # world map
      gnome-music
      gnome-text-editor
      gnome-tour
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      hitori # sudoku game
      iagno # go game
      seahorse
      tali # poker game
      totem # movie player
      yelp # Help view
    ];

    environment.systemPackages =
      (with pkgs; [
        gnome-tweaks
        whitesur-gtk-theme
      ])
      ++ (with pkgs.gnomeExtensions; [
        appindicator
        blur-my-shell
        caffeine
        compiz-alike-magic-lamp-effect
        #compiz-windows-effect
        dash-to-dock
        fullscreen-avoider
        just-perfection
        kimpanel
      ]);
  };
}
