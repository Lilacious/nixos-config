{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.zathura;
in
{
  options = {
    myHome.programs.zathura = {
      enable = mkEnableOption "Zathura document viewer";
    };
  };
  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        database = "sqlite";
      };
    };
  };
}
