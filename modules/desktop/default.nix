{ config, lib, pkgs, ... }:

with lib;
let 
  cfg = config.myModules.desktop;
in
{
  imports = [
    ./gtk.nix
    ./hyprland.nix
    ./plasma.nix
    ./xdg.nix
  ];

  options = {
    myModules.desktop = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      windowManager = {
        enable = mkOption {
          type = types.bool;
          default = cfg.wayland||cfg.xserver;
        };
        wayland = mkOption {
          type = types.bool;
          default = false;
        };
        xserver = mkOption {
          type = types.bool;
          default = false;
        };
      };
    };
  };

  config = mkIf (config.myModules.desktop.enable) {
    services.xserver = {
      enable = mkDefault false;
      xkb.layout = mkDefault "de";
      excludePackages = with pkgs; [ xterm ];
    };

    # Enable sound with pipewire.
    sound.enable = false;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    security.polkit.enable = true;

    ## Firefox
    programs.firefox = {
      enable = true;
    };

    myModules = {
      programs = {
        alacritty.enable = true;
      };
    };
  };
}
