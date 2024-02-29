{ config, lib, pkgs, ... }:

with lib;
{
  imports = [
    ./plasma5.nix
    ./gtk.nix
  ];

  options = {
    myModules.desktop = {
      enable = mkOption {
        type = types.bool;
        default = false;
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
      # Audio crackling fix
      #extraConfig.pipewire = {
      #  "context.properties" = [{
      #    "link.max-buffers" = 128;
      #    "default.clock.allowed-rates" = [ 44100 48000 96000 ];
      #    "default.clock.rate" = 48000;
      #    "default.clock.quantum" = 512;
      #    "default.clock.min-quantum" = 32;
      #    "default.clock.max-quantum" = 8192;
      #  }];
      #};
    };

    ## Real-time microphone noise suppression
    programs.noisetorch.enable = true; 
  
    security.polkit.enable = true;
    ## GNOME programs
    programs.dconf.enable = true;

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
