{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.myModules.desktop;
in {
  config = mkIf cfg {
    services.xserver = {
      # Disable xserver by default
      enable = mkDefault false;
      # Set keymap to German
      xkb.layout = mkDefault "de";
      # Disable xterm
      excludePackages = with pkgs; [xterm];
    };

    # Enable polkit
    security.polkit.enable = true;
    # Run GNOME applications
    programs.dconf.enable = true;
  };
}
