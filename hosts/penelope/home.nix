{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/starship.nix
    ../../modules/home/pkgs.nix
    ../../modules/home/alacritty.nix
    ../../modules/home/hyprland.nix
  ];
  programs.zsh.shellAliases = {
    openFrontDoor = "ssh door@bourbon.w17.io buzzer";
    openSesame = "ssh door@bourbon.w17.io open";
    closeSesame = "ssh door@bourbon.w17.io close";
  };
  home.username = "yunix";
  home.homeDirectory = "/home/yunix";

  home.stateVersion = "23.11";
}