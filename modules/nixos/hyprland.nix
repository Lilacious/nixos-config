{ pkgs, inputs, variables, ... }:
{
  imports = [
    inputs.hyprland.nixosModules.default
    ./battery.nix
  ];

  programs.light.enable = true;

  # Group for light
  users.users.${variables.username} = {
    extraGroups = [ "video" ];
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Swaylock fix
  security.pam.services.swaylock = {};

  # Graphical file manager
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

}
