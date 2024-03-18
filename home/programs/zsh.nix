# For system config see nix-config/modules/core/zsh.nix
{
  config,
  osConfig,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.programs.zsh;
  osCfg = osConfig.myModules.core.zsh;
in {
  options = {
    myHome.programs.zsh = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
      };
    };
  };
  config = mkIf (cfg.enable) {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
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
