{ variables, ... }:
{
  home-manager.users.${variables.username} = {
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

      historySubstringSearch = {
        enable = true;
        searchUpKey = "$terminfo[kcuu1]";
        searchDownKey = "$terminfo[kcud1]";
      };

      shellAliases = {
        ls = "eza -g";
        ll = "eza -l";
        la = "eza -a";
        tree = "eza -T";
        c = "clear";
        update = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#$HOST";
      };
    };
  };

  ## For programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];
  ## Enable zsh system-wide
  programs.zsh.enable = true;
}
