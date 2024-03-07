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
    };
  };

  ## For programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];
  ## Enable zsh system-wide
  programs.zsh.enable = true;
}
