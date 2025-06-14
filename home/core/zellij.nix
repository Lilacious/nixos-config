{
  config,
  lib,
  options,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.zellij;
  bind = keys: action: {
    name = "bind \"${keys}\"";
    value = {
      "${action}" = [ ];
    };
  };
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
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        settings = {
          pane_frames = false;
          show_startup_tips = false;
          show_release_notes = false;

          keybinds = {
            "shared_except \"locked\"" = builtins.listToAttrs [
              (bind "Alt m" "ToggleFocusFullscreen;")
              (bind "Alt q" "CloseFocus;")
              (bind "Alt w" ''
                LaunchOrFocusPlugin "session-manager" {
                  floating true
                  move_to_focused_tab true
                };'')
              (bind "Alt e" "FocusNextPane;")
              (bind "Alt r" "GoToNextTab;")
            ];
          };
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
