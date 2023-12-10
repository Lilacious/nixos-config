{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myModules.programs.firefoxDevedition;
in
{
  options = {
    myModules.programs.firefoxDevedition = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      (runCommand "firefox-dev" { preferLocalBuild = true; } ''
        mkdir -p $out/bin
        ln -s ${pkgs.firefox-devedition}/bin/firefox $out/bin/firefox-devedition
      '')
      (pkgs.makeDesktopItem {
        name = "firefox-devedition";
        exec = "firefox-devedition";
        icon = "firefox-developer-edition";
        desktopName = "Firefox Developer Edition";
        genericName = "Web Browser";
        categories = [ "Network" "WebBrowser" ];
      })
    ];
  };
}
