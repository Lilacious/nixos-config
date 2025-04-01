{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.zellij;
in
{
  options = {
    myHome.programs.zellij = {
      enable = mkEnableOption "terminal workspace";
    };
  };
  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        theme = "catppuccin-mocha";
        pane_frames = false;
        ui.pane_frames.hide_session_name = true;
        show_startup_tips = false;
        show_release_notes = false;
      };
    };
  };
}
