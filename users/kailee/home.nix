{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix
  ];
  home.username = "kailee";
  home.homeDirectory = "/home/kailee";

  home.stateVersion = "22.11";
}
