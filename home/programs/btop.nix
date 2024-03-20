{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.programs.btop;
  catppuccin-btop = pkgs.callPackage ../../pkgs/catppuccin-btop/package.nix {};
in {
  options = {
    myHome.programs.btop = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [catppuccin-btop];
    xdg.configFile = {
      "btop/themes".source = "${catppuccin-btop}/share/btop/themes";
    };
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "catppuccin_mocha";
      };
    };
  };
}
