{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  fcitx5-catppuccin = pkgs.callPackage ../../pkgs/fcitx5-catppuccin/package.nix {};
  cfg = config.myModules.desktop;
in {
  config = {
    i18n.inputMethod = mkIf cfg.enable (mkMerge [
      {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [
          ## Japanese IM
          fcitx5-mozc
          ## Chinese pinyin IM
          fcitx5-chinese-addons

          fcitx5-gtk
        ];
      }
      (mkIf cfg.plasma.enable {
        fcitx5.addons = with pkgs; [
          kdePackages.fcitx5-qt
          fcitx5-catppuccin
        ];
      })
    ]);
  };
}
