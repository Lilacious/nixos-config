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

    plugins = [ 
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";     
      } 
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    shellAliases = {
      ll = "ls -l";
      update = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#sisyphos && cd -";
    };
  };
}
