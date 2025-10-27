# For home config see nix-config/home/desktop/plasma.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop;
in
{
  options = {
    myModules.desktop.plasma = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.plasma.enable {
    myModules = {
      desktop.desktopEnvironment.enable = true;
      other.inputMethod.qt = mkDefault true;
    };

    services.desktopManager.plasma6.enable = true;

    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [
        konsole # terminal
        elisa # music player
        kate # text editor
        khelpcenter # kde documentation
        okular # document viewer
        krdp # rdp application
      ];
    };
  };
}
