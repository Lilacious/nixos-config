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
        fcitx5-mozc
        fcitx5-gtk
      ];
    })
    (mkIf config.myModules.desktop.plasma5.enable {
      fcitx5.addons = with pkgs; [
        libsForQt5.fcitx5-qt
        fcitx5-catppuccin
      ];
    })
  ]);

  environment.systemPackages = [
  ];
}
