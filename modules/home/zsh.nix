{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      ignoreSpace = true;
      size = 500000;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -l";
      c = "clear";
      update = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#$HOST";
      edit-packages = "vim ~/nixos-config/hosts/$HOST/packages.nix";
      edit-common-pkgs = "vim ~/nixos-config/modules/nixos/common/common-pkgs.nix";
    };
  };
}
