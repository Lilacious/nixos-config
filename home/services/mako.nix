{
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myHome.services.mako;
in
{
  options = {
    myHome.services.mako = {
      enable = mkEnableOption "mako";
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      services.mako = {
        enable = true;
        settings = {};
      };
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          stylix.targets.mako.enable = true;
        }
      else
        { }
    )
  ]);
}
