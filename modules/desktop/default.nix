{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop;
  anyEnabled = any (d: cfg.${d}.enable);
  desktopEnvironments = [
    "cosmic"
    "gnome"
    "plasma"
  ];
  windowManagers = [
    "hyprland"
    "niri"
  ];
in
{
  imports = [
    ./audio.nix
    ./cosmic.nix
    ./gnome.nix
    ./hyprland.nix
    ./multi.nix
    ./niri.nix
    ./plasma.nix
    ./plymouth.nix
    ./printing.nix
  ];

  options = {
    myModules.desktop = {
      enable = mkOption {
        type = types.bool;
        default = cfg.desktopEnvironment.enable || cfg.windowManager.enable;
      };

      # derived from the lists above, not meant to be set
      desktopEnvironment.enable = mkOption {
        type = types.bool;
        default = anyEnabled desktopEnvironments;
        readOnly = true;
      };

      windowManager.enable = mkOption {
        type = types.bool;
        default = anyEnabled windowManagers;
        readOnly = true;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.firefox.enable = true;

    # Enable audio
    myModules = {
      other.fonts.enable = true;
      programs.desktop.enable = true;
    };

    services.xserver = {
      # Disable xserver by default
      enable = mkDefault false;
      # Set keymap to German
      xkb.layout = mkDefault "de";
      # Disable xterm
      excludePackages = with pkgs; [ xterm ];
    };

    # gnome-keyring brings its own agent, both cannot be enabled
    myModules.programs.sshAgent.enable = mkDefault (!config.services.gnome.gcr-ssh-agent.enable);

    # Enable polkit
    security.polkit.enable = true;
    # Run GNOME applications
    programs.dconf.enable = true;
  };
}
