{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.programs.zoxide;
in {
  options = {
    myHome.programs.zoxide = {
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
    home.shellAliases = {
      cd = "z"; # zoxide
      cdf = "zi"; # z with fzf
    };
  };
}
