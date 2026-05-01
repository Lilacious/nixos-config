{
  config,
  lib,
  options,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.helix;
in
{
  options = {
    myHome.programs.helix = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    ({
      programs.helix = {
        enable = true;
        settings = {
          keys.normal = {
            space.w = ":w";
            space.q = ":q";
            esc = [
              "collapse_selection"
              "keep_primary_selection"
            ];
          };
        };
      };
    })
    (
      if (builtins.hasAttr "stylix" options) then
        {
          stylix.targets.helix.enable = true;
        }
      else
        { }
    )
  ]);
}
