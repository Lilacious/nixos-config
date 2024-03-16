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
        default = true;
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
    home.shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      tree = "eza -T";
    };
  };
}
