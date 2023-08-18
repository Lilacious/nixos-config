{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/starship.nix
    ../../modules/home/pkgs.nix
    ../../modules/home/alacritty.nix
    ../../modules/home/themes.nix


  ];
  programs.zsh.shellAliases = {
    openFrontDoor = "ssh door@bourbon.w17.io buzzer";
    openSesame = "ssh door@bourbon.w17.io open";
    closeSesame = "ssh door@bourbon.w17.io close";
  };
  home.username = "kailee";
  home.homeDirectory = "/home/kailee";

  home.stateVersion = "22.11";
}
