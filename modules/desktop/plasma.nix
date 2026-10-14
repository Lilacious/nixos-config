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
    myModules.other.inputMethod.enable = mkDefault true;

    services.desktopManager.plasma6.enable = true;

    environment = {
      plasma6.excludePackages =
        with pkgs.kdePackages;
        [
          elisa # music player
          kate # text editor
          khelpcenter # kde documentation
          krdp # rdp application
          ktexteditor # elevated actions for kate
          okular # document viewer
          plasma-browser-integration
          plasma-keyboard # touch keyboard
          qrca # qr code scanner
          qtvirtualkeyboard # used by plasma-keyboard
        ]
        # only needed for the plasma x11 session
        ++ optional (!config.services.xserver.enable) kwin-x11;
    };
  };
}
