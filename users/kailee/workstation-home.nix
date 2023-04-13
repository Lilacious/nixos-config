{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/pkgs.nix
  ];
  home.username = "kailee";
  home.homeDirectory = "/home/kailee";

  home.stateVersion = "22.11";
}
