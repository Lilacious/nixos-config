# resolves conflicts between desktops, when multiple are enabled
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop;
  inherit (cfg) primary;
  multiple = length cfg.enabledDesktops > 1;
  # Plasma ranks first, so it is primary whenever it is enabled
  plasma = primary == "plasma";

  priority = [
    "plasma"
    "gnome"
    "niri"
    "cosmic"
    "hyprland"
  ];

  prefer = mkOverride 900;

  # login screen of the primary desktop, else gdm
  greeter =
    {
      plasma = "sddm";
      niri = "noctalia-greeter";
      cosmic = "cosmic-greeter";
    }
    .${primary} or "gdm";
in
{
  options.myModules.desktop = {
    enabledDesktops = mkOption {
      type = types.listOf (types.enum priority);
      default = filter (d: cfg.${d}.enable) priority;
      readOnly = true;
      description = "Enabled desktops, sorted by priority.";
    };

    primary = mkOption {
      type = types.nullOr (types.enum priority);
      default = if cfg.enabledDesktops == [ ] then null else head cfg.enabledDesktops;
      readOnly = true;
      description = "Highest priority enabled desktop.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.displayManager = {
        enable = true;
        sddm = {
          enable = mkIf (greeter == "sddm") true;
          wayland.enable = true;
        };
        gdm.enable = mkIf (greeter == "gdm") true;
        noctalia-greeter.enable = mkIf (greeter == "noctalia-greeter") true;
        cosmic-greeter.enable = mkIf (greeter == "cosmic-greeter") true;
      };
    }

    (mkIf multiple {
      services.displayManager.defaultSession = prefer primary;

      # KWallet conflict
      services.gnome.gnome-keyring.enable = mkIf plasma (prefer false);
      xdg.portal.config.niri = mkIf (plasma && cfg.niri.enable) {
        "org.freedesktop.impl.portal.Secret" = mkForce "kwallet";
      };

      # Dolphin and Nautilus conflict
      programs.niri.useNautilus = mkIf plasma (prefer false);

      # GNOME and Plasma both set askPassword
      programs.ssh.askPassword = mkIf (plasma && config.programs.seahorse.enable) (
        prefer "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass"
      );

      # override QT_QPA_PLATFORMTHEME=qt5ct cosmic sets globally
      qt.platformTheme = mkIf (plasma && cfg.cosmic.enable) (prefer "kde");
    })
  ]);
}
