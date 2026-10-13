{
  config,
  lib,
  options,
  pkgs,
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
        # default Nix language server
        extraPackages = [ pkgs.nil ];
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
    (optionalAttrs (options ? stylix) {
      stylix.targets.helix.enable = true;
    })
  ]);
}
