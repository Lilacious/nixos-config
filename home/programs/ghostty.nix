{
  config,
  lib,
  pkgs,
  options,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.ghostty;
in
{
  options = {
    myHome.programs.ghostty = {
      enable = mkEnableOption "Ghostty";
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        settings = {
          font-size = 12;
          scrollback-limit = 10000;
          # Ship the xterm-ghostty terminfo entry to hosts we ssh into, so
          # remote shells get a TERM they can actually look up.
          shell-integration-features = "ssh-env,ssh-terminfo";
        };
      };
      home.packages = with pkgs; [
        ## Terminfo for terminals
        ghostty.terminfo
      ];
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          stylix.targets.ghostty.enable = true;
        }
      else
        { }
    )
  ]);
}
