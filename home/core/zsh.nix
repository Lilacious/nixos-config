# For system config see nix-config/modules/core/zsh.nix
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.zsh;
in
{
  options = {
    myHome.programs.zsh = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
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

      # historySubstringSearch broken by
      # https://github.com/nix-community/home-manager/commit/04f672b5db5ed5b2fa56aff523089cd29049cb4d
      historySubstringSearch = {
        # disable current config
        # enable = true;
        searchUpKey = "$terminfo[kcuu1]";
        searchDownKey = "$terminfo[kcud1]";
      };
      # use old config
      initContent =
        let
          cfg = config.programs.zsh;
        in
        lib.mkOrder 1250 ''
          source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
          ${lib.concatMapStringsSep "\n" (upKey: ''bindkey "${upKey}" history-substring-search-up'') (
            lib.toList cfg.historySubstringSearch.searchUpKey
          )}
          ${lib.concatMapStringsSep "\n" (downKey: ''bindkey "${downKey}" history-substring-search-down'') (
            lib.toList cfg.historySubstringSearch.searchDownKey
          )}
        '';
    };
  };
}
