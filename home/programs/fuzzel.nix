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
      enable = mkEnableOption "fuzzel launcher";
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.fuzzel = {
        enable = true;
      };
    }
    (optionalAttrs (options ? stylix) {
      stylix.targets.fuzzel.enable = true;
    })
  ]);
}
