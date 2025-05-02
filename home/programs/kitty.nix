{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.kitty;
in
{
  options = {
    myHome.programs.kitty = {
      enable = mkEnableOption "Kitty";
    };
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      shellIntegration = {
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
      themeFile = "Catppuccin-Mocha";
      font = {
        # looks blurry apparently due to no Sub-pixel anti-aliasing
        name = "Agave Nerd Font";
        size = 12;
      };
      settings = {
        remember_window_size = false;
        initial_window_width = "125c";
        initial_window_height = "37c";
        scrollback_lines = 10000;
        enable_audio_bell = false;
        update_check_interval = 0;
        confirm_os_window_close = 2;
      };
    };
  };
}
