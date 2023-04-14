{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history = {
      ignoreSpace = true;
      size = 5000000;
      ignoreDups = true;
    };
    historySubstringSearch.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#$HOST";
    };
  };
}
