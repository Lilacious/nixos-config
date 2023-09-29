{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/starship.nix
    ../../modules/home/alacritty.nix
    ../../modules/home/hyprland.nix
  ];

  programs.zsh = {
    shellAliases = {
      open-front-door = "ssh door@bourbon.w17.io buzzer";
      open-sesame = "ssh door@bourbon.w17.io open";
      close-sesame = "ssh door@bourbon.w17.io close";
      battery-info-internal = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
      battery-info-external = "upower -i /org/freedesktop/UPower/devices/battery_BAT1";
    };

    # Start Hyprland after login if standard user and current tty is tty1
    loginExtra = ''
      if [ $UID -ge 1000 ] && [ $(tty) = "/dev/tty1" ]; then
        Hyprland
      fi
      '';
  };
  home.username = "yunix";
  home.homeDirectory = "/home/yunix";

  home.stateVersion = "23.11";
}
