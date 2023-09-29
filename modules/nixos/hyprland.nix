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

}
