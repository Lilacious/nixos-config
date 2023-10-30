{ config, lib, variables, pkgs, ... }:

with lib;
{
  imports = [
    ./plasma5.nix
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
      layout = mkDefault "de";
      excludePackages = with pkgs; [ xterm ];
    };
  
    # Enable sound with pipewire.
    sound.enable = true;
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
  
    ## GNOME programs
    programs.dconf.enable = true;
  
    home-manager.users.${variables.username} = {
      programs.alacritty.enable = true;
    };
  };
}
