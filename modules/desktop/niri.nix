# For home config see nix-config/home/desktop/niri.nix
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
    myModules.desktop.niri = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.niri.enable {
    programs.niri.enable = true;

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      systemPackages = with pkgs; [
        xwayland-satellite
        wl-clipboard
      ];
    };
  };
}
