{ config, pkgs, lib, ... }:

with lib;
let 
  fcitx5-catppuccin = pkgs.callPackage ../../pkgs/fcitx5-catppuccin/package.nix {};
in
{
  i18n.inputMethod = mkIf config.myModules.desktop.enable (mkMerge [
    ({
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        ## Japanese IM
        fcitx5-mozc
        ## Chinese pinyin IM
        fcitx5-chinese-addons

        fcitx5-gtk
      ];
    })
    (mkIf config.myModules.desktop.plasma.enable {
      fcitx5.addons = with pkgs; [
        kdePackages.fcitx5-qt
        fcitx5-catppuccin
      ];
    })
  ]);

  environment.systemPackages = [
  ];
}
