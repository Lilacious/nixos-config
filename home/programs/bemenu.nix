{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.programs.bemenu;
  WM = config.myHome.desktop.windowManager;
in {
  options = {
    myHome.programs.bemenu = {
      enable = mkOption {
        type = types.bool;
        default = WM.enable;
      };
    };
  };
  config = mkIf cfg.enable {
    programs.bemenu = {
      enable = true;
      settings = {
        list = 20;
        prompt = ">";
        ignorecase = true;

        width-factor = 0.2;
        center = true;
        border = 1;
        border-radius = 10;
        # Catppuccin mocha
        fb = "#1e1e2e";
        ff = "#cdd6f4";
        nb = "#1e1e2e";
        nf = "#cdd6f4";
        tb = "#1e1e2e";
        hb = "#1e1e2e";
        tf = "#f38ba8";
        hf = "#f9e2af";
        af = "#cdd6f4";
        ab = "#1e1e2e";
      };
    };
  };
}
