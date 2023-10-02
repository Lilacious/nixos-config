{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/starship.nix
    ../../modules/home/alacritty.nix

  ];

  programs.zsh = {
    shellAliases = {
      foo = "bar";
    };
  };
  home.username = "yunix";
  home.homeDirectory = "/home/yunix";

  home.stateVersion = "23.11";
}
