{
  config,
  lib,
  options,
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
