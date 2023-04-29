{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/starship.nix
    ../../modules/home/pkgs.nix
    ../../modules/home/alacritty.nix
    ../../modules/home/themes.nix
    ../../modules/home/kitty.nix
  ];
  home.username = "kailee";
  home.homeDirectory = "/home/kailee";

  home.stateVersion = "22.11";
}
