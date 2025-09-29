{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.programs.desktop;
in
{
  options = {
    myModules.programs.desktop = {
      enable = mkEnableOption "default desktop applications";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ## Password manager
      keepassxc

      ## Network
      networkmanagerapplet

      ## Communication
      mumble
      # discord
      vesktop
      element-desktop

      ## Other
      thunderbird # email client
      xournalpp
      spotify
      parsec-bin # remote desktop client
      obs-studio
      #jellyfin-media-player
    ];
  };
}
