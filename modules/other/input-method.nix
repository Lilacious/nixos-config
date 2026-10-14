{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.other.inputMethod;
in
{
  options = with types; {
    myModules.other.inputMethod = {
      # gtk and qt frontends are always included by nixpkgs
      enable = mkEnableOption "fcitx5";
    };
  };

  config = {
    i18n.inputMethod = mkIf cfg.enable {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        ## Japanese IM
        fcitx5-mozc
        ## Chinese pinyin IM
        qt6Packages.fcitx5-chinese-addons

        catppuccin-fcitx5
      ];
    };
  };
}
