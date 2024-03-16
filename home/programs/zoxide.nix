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
      zoxide = {
        enable = true;
      };
    };
    shellAliases = {
      cd = "z"; # zoxide
      cdf = "zi"; # z with fzf
    };
  };
}
