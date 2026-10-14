# For home config see nix-config/home/desktop/hyprland.nix
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
    myModules.desktop.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      terminal = mkOption {
        type = types.str;
        default = "alacritty";
      };

      browser = mkOption {
        type = types.str;
        default = "firefox";
      };

      settings = mkOption {
        type =
          with lib.types;
          let
            valueType =
              nullOr (oneOf [
                bool
                int
                float
                str
                path
                (attrsOf valueType)
                (listOf valueType)
              ])
              // {
                description = "Hyprland configuration value";
              };
          in
          valueType;
        default = {
          monitor = [
            {
              output = "";
              mode = "preferred";
              position = "auto";
              scale = 1;
            }
          ];
        };
      };
    };
  };

  config = mkIf cfg.hyprland.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = mkForce false;
    };
    programs.uwsm.enable = mkForce false;

    # secret service for apps and noctalia, like programs.niri sets it
    services.gnome.gnome-keyring.enable = mkDefault true;

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      systemPackages = with pkgs; [
        wl-clipboard
      ];
    };
  };
}
