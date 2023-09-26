{ pkgs, inputs, ... }:
{
  imports = [
    ./battery.nix
  ];
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Swaylock fix
  security.pam.services.swaylock = {};

}
