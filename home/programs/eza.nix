{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.programs.eza;
in {
  options = {
    myHome.programs.eza = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    programs = {
      eza = {
        enable = true;
        icons = true;
        extraOptions = [
          "--group"
          "--group-directories-first"
          "--blocksize"
        ];
      };
    };
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      tree = "eza -T";
    };
  };
}
