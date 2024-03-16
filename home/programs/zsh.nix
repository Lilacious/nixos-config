# For system config see nix-config/modules/core/zsh.nix
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.programs.zsh;
in {
  options = {
    myHome.programs.zsh = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
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
}
