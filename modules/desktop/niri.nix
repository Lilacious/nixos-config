# For home config see nix-config/home/desktop/niri.nix
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop.niri;
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

  imports = [ inputs.niri.nixosModules.niri ];

  config = mkIf cfg.enable {
    myModules.desktop.windowManager.enable = true;

    programs.niri.enable = true;
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri.package = pkgs.niri-unstable;
    environment = {
      variables.NIXOS_OZONE_WL = "1";

      systemPackages = with pkgs; [
        wl-clipboard
        wayland-utils
        swaybg
      ];
    };
  };
}
