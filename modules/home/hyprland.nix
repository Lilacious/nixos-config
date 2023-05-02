## dependent on hyprland flake input
{ pkgs, config, ... }:
{ 
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig =  ''
      bind = SUPER, Return, exec, alacritty

    '';
  };
}
