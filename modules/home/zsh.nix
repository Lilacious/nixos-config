{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history = {
      ignoreSpace = true;
      size = 500000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -l";
      c = "clear";
      update = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#$HOST";
    };
  };
}
