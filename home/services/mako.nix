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
      home.packages = [ pkgs.libnotify ];
      services.mako = {
        enable = true;
        settings = {
          border-radius = 10;
          border-size = 2;
          default-timeout = 5000;
          height = 200;
          width = 325;
          anchor = "bottom-right";
          padding = "10";
          margin = "10";
          outer-margin = "20,10";
        };
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
