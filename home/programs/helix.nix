{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.helix;
  catppuccin-helix = pkgs.callPackage ../../pkgs/catppuccin-helix/package.nix { };
in
{
  options = {
    myHome.programs.helix = {
      enable = mkEnableOption "helix editor";
    };
  };
  config = mkIf cfg.enable {
    xdg.configFile."helix/themes/catppuccin.toml".source =
      "${catppuccin-helix}/share/helix/themes/default/catppuccin_mocha.toml";

    programs.helix = {
      enable = true;
      settings = {
        theme = "catppuccin";
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
  };
}
