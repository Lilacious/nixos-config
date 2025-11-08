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
      enable = mkEnableOption "fcitx5" // {
        default = cfg.gtk || cfg.qt;
      };
      gtk = mkEnableOption "fcitx5-gtk";
      qt = mkEnableOption "fcitx5-qt";
    };
  };

  config = {
    i18n.inputMethod = mkIf cfg.enable (mkMerge [
      {
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
      }
      (mkIf cfg.gtk {
        fcitx5.addons = with pkgs; [
          fcitx5-gtk
        ];
      })
      (mkIf cfg.qt {
        fcitx5.addons = with pkgs; [
          kdePackages.fcitx5-qt
        ];
      })
    ]);
  };
}
