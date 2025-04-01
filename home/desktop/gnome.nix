# For system config see nix-config/modules/desktop/gnome.nix
{
  config,
  osConfig,
  lib,
  ...
}:
with lib;
let
  cfg = config.myHome.desktop.gnome;
  osCfg = osConfig.myModules.desktop.gnome;
in
{
  options = {
    myHome.desktop.gnome = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
      };
    };
  };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
          gtk-enable-primary-paste = false;
        };

        "org/gnome/desktop/peripherals/touchpad" = {
          natural-scroll = false;
          click-method = "areas";
        };

        "org/gnome/mutter" = {
          edge-tiling = true;
          center-new-windows = true;
          dynamic-workspaces = false;
        };

        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-temperature = "uint32 4000";
          night-light-schedule-automatic = false;
          night-light-schedule-from = "0.0";
          night-light-schedule-to = "0.0";
        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          focus-mode = "click";
          num-workspaces = 10;
        };

        "org/gnome/shell" = {
          favorite-apps = [
            "org.gnome.Settings.desktop"
            "org.gnome.Nautilus.desktop"
            "firefox.desktop"
            "Alacritty.desktop"
            "codium.desktop"
          ];
        };

        "org/gnome/shell/app-switcher" = {
          current-workspace-only = true;
        };

        "org/gnome/shell/keybindings" = {
          toggle-message-tray = [ ];
          focus-active-notification = [ ];

          switch-to-application-1 = [ ];
          switch-to-application-2 = [ ];
          switch-to-application-3 = [ ];
          switch-to-application-4 = [ ];
          switch-to-application-5 = [ ];
          switch-to-application-6 = [ ];
          switch-to-application-7 = [ ];
          switch-to-application-8 = [ ];
          switch-to-application-9 = [ ];
          switch-to-application-10 = [ ];
        };

        "org/gnome/mutter/wayland/keybindings" = {
          restore-shortcuts = [ ];
        };

        "org/gnome/desktop/wm/keybindings" = {
          maximize = [ ];
          minimize = [ "<Super>comma" ];
          toggle-maximized = [ "<Super>m" ];
          toggle-fullscreen = [ "<Super>f" ];
          close = [
            "<Super>q"
            "<Alt>F4"
          ];
          switch-applications = [ ];
          switch-applications-backward = [ ];
          switch-windows = [ "<Alt>Tab" ];
          switch-windows-backward = [ "<Shift><Alt>Tab" ];
          switch-to-workspace-left = [
            "<Super>Page_Up"
            "<Shift><Super>Tab"
          ];
          switch-to-workspace-right = [
            "<Super>Page_Down"
            "<Super>Tab"
          ];
          panel-run-dialog = [
            "<Alt>F2"
            "<Super>r"
          ];

          switch-to-workspace-1 = [ "<Super>1" ];
          switch-to-workspace-2 = [ "<Super>2" ];
          switch-to-workspace-3 = [ "<Super>3" ];
          switch-to-workspace-4 = [ "<Super>4" ];
          switch-to-workspace-5 = [ "<Super>5" ];
          switch-to-workspace-6 = [ "<Super>6" ];
          switch-to-workspace-7 = [ "<Super>7" ];
          switch-to-workspace-8 = [ "<Super>8" ];
          switch-to-workspace-9 = [ "<Super>9" ];
          switch-to-workspace-10 = [ "<Super>0" ];
          move-to-workspace-1 = [ "<Shift><Super>1" ];
          move-to-workspace-2 = [ "<Shift><Super>2" ];
          move-to-workspace-3 = [ "<Shift><Super>3" ];
          move-to-workspace-4 = [ "<Shift><Super>4" ];
          move-to-workspace-5 = [ "<Shift><Super>5" ];
          move-to-workspace-6 = [ "<Shift><Super>6" ];
          move-to-workspace-7 = [ "<Shift><Super>7" ];
          move-to-workspace-8 = [ "<Shift><Super>8" ];
          move-to-workspace-9 = [ "<Shift><Super>9" ];
          move-to-workspace-10 = [ "<Shift><Super>0" ];
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "alacritty";
          command = "alacritty";
          binding = "<Super>Return";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          name = "firefox";
          command = "firefox";
          binding = "<Super>b";
        };

        "org/gnome/shell" = {
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "apps-menu@gnome-shell-extensions.gcampax.github.com"
            "dash-to-dock@micxgx.gmail.com"
            "compiz-alike-magic-lamp-effect@hermes83.github.com"
            "user-theme@gnome-shell-extensions.gcampax.github.com"
            "places-menu@gnome-shell-extensions.gcampax.github.com"
            "blur-my-shell@aunetx"
            "kimpanel@kde.org"
            "just-perfection-desktop@just-perfection"
            "caffeine@patapon.info"
            "fullscreen-avoider@noobsai.github.com"
          ];
        };

        "org/gnome/shell/extensions/user-theme" = {
          name = "WhiteSur-Dark";
        };

        "org/gnome/shell/extensions/dash-to-dock" = {
          hot-keys = false;
          # multi-monitor = true; # Disabled due to theme missmatch
          apply-custom-them = true;
        };

        "org/gnome/shell/extensions/just-perfection" = {
          startup-status = 0;
          search = false;
          workspace-wrap-around = true;
          workspaces-in-app-grid = false;
        };
      };
    };
  };
}
