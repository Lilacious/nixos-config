{
  config,
  lib,
  options,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.zellij;
in
{
  options = {
    myHome.programs.zellij = {
      enable = mkEnableOption "terminal workspace" // {
        default = true;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.zellij = {
        enable = true;
        attachExistingSession = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        exitShellOnExit = true;
        settings = {
          pane_frames = false;
          show_startup_tips = false;
          show_release_notes = false;
        };
      };
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          programs.zellij.themes.stylix =
            let
              inherit (config.lib.stylix) colors;
            in
            {
              themes = with colors.withHashtag; {
                default = {
                  bg = base03;
                  fg = base07;
                  red = base08;
                  green = base0B;
                  blue = base0D;
                  yellow = base0A;
                  magenta = base0E;
                  orange = base09;
                  cyan = base0C;
                  black = base00;
                  white = base05;
                };
              };
            };
        }
      else
        {
          programs.zellij.settings.theme = "catppuccin-mocha";
        }
    )
  ]);
}
