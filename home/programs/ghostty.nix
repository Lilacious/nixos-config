{
  config,
  lib,
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
  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        font-size = 12;
        font-family = "Agave Nerd Font";
        theme = "catppuccin-mocha";
        scrollback-limit = 10000;
      };
    };
  };
}
