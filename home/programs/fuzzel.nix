{
  config,
  lib,
  options,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.fuzzel;
in
{
  options = {
    myHome.programs.fuzzel = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.fuzzel = {
        enable = true;
      };
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          stylix.targets.fuzzel.enable = true;
        }
      else
        { }
    )
  ]);
}
