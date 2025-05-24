{
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.yazi;
in
{
  options = {
    myHome.programs.yazi = {
      enable = mkEnableOption "Yazi" // {
        default = true;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    ({
      programs.yazi = {
        enable = true;
        settings = {
          log = {
            enabled = false;
          };
        };
      };
      home.packages = [ pkgs.ueberzugpp ];
    })
    (
      if (builtins.hasAttr "stylix" options) then
        {
          stylix.targets.yazi.enable = true;
        }
      else
        { }
    )
  ]);
}
