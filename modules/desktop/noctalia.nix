# noctalia, the shell of the window managers, and its greeter
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop;
  normalUsers = attrNames (filterAttrs (_: u: u.isNormalUser) config.users.users);
  # the unit each window manager starts its session with
  sessionUnits = {
    niri = "niri.service";
    hyprland = "hyprland-session.target";
  };
  # enabled window managers, by priority
  shells = filter (d: cfg.${d}.enable) [
    "niri"
    "hyprland"
  ];
  units = map (s: sessionUnits.${s}) shells;
in
{
  config = mkIf (shells != [ ]) {
    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
      systemd.enable = true;
    };

    # start only with these sessions, not with every graphical-session.target (Plasma, GNOME)
    systemd.user.services.noctalia = {
      partOf = mkForce units;
      after = mkForce units;
      wantedBy = mkForce units;
    };

    # login card styled like a macOS 27 UI kit component (the kit has no login screen;
    # its dark alerts and popovers are the closest); the wallpaper comes from noctalia's
    # greeter sync ([shell.greeter_sync] in the noctalia config)
    services.displayManager.noctalia-greeter = {
      settings = {
        # a single account opens straight at its password, like a one-user Mac
        user = mkIf (length normalUsers == 1) { default = head normalUsers; };
        session.default = head shells;
        appearance = {
          scheme = "Synced";
          hide_logo = true;
          scheme_selector_position = "hidden";
          password_style = "default";
          theme_mode = "dark";
          corner_radius_scale = 2.0; # the greeter's maximum: ~19pt corners, the kit popover's 20
          font_family = "Inter";
          # measured from the kit's glass and dark alerts; a full palette here wins over
          # the one noctalia syncs
          palette = {
            # the card: the kit's dark Liquid Glass, #1b1b1b at 75% (fitted over its
            # gray stripes), so the wallpaper shows through
            surface_variant = "#1b1b1bbf";
            surface = "#ffffff14"; # password field and session picker: frosted, a white tint
            outline = "#ffffff2e"; # the glass rim, and the field borders
            primary = "#cba6f7"; # Catppuccin Mocha Mauve, the shell's accent
            on_primary = "#1e1e2e"; # Catppuccin Mocha base: dark text on the pale accent
            on_surface = "#ffffff"; # kit text is pure white
            on_surface_variant = "#8c8c8c"; # placeholder and secondary text
            secondary = "#8c8c8c";
            on_secondary = "#1a1a1a";
            tertiary = "#30d158";
            on_tertiary = "#000000";
            error = "#ff453a";
            on_error = "#ffffff";
            shadow = "#000000";
            hover = "#ffffff1f";
            on_hover = "#ffffff";
          };
        };
      };
      passwordlessSyncUsers = normalUsers;
      cursorTheme = {
        name = "WhiteSur-cursors";
        package = pkgs.whitesur-cursors;
      };
    };
  };
}
