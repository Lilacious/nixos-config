{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
  ];
  home.username = "kailee";
  home.homeDirectory = "/home/kailee";

  home.stateVersion = "22.11";
}
