{ config, pkgs, lib, ... }:

with lib;
{
  i18n.inputMethod = mkIf config.myModules.desktop.enable (mkMerge [
    ({
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
      ];
    })
    (mkIf config.myModules.desktop.plasma5.enable {
      fcitx5.addons = with pkgs; [
        libsForQt5.fcitx5-qt
      ];
    })
  ]);
}
