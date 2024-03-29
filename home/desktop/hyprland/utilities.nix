{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpaper
      hyprpicker
      grimblast
      wlr-randr
      pavucontrol
      brillo
      # QT wayland support
      kdePackages.qtwayland
      libsForQt5.qt5.qtwayland
      # Polkit agent and dependency
      kdePackages.polkit-kde-agent-1
      kdePackages.kirigami
      # Fix GTK-WARNING: cannot open display
      xorg.xhost
      # XDG desktop file picker
      xdg-desktop-portal-gtk
    ];

    wayland.windowManager.hyprland = {
      plugins = [
      ];
      settings = {
        env = [
          "GDK_BACKEND,wayland,x11"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_QPA_PLATFORMTHEME,kde" # use kde theme
          "SDL_VIDEODRIVER,wayland"
          "CLUTTER_BACKEND,wayland"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "GTK_IM_MODULE,"
          "QT_IM_MODULE,"
        ];

        exec-once = [
          "mako"
          "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
          "xhost +SI:localuser:root"
          "waybar"
          "fcitx5"
        ];
      };
    };
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      splash = false
      preload = ~/Pictures/Wallpapers/KDEScarlettTreeDark.png
      wallpaper = ,~/Pictures/Wallpapers/KDEScarlettTreeDark.png
    '';

    systemd.user.services.hyprpaper = {
      Unit = {
        Description = "Hyprland wallpaper daemon";
        PartOf = ["hyprland-session.target"];
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.hyprpaper}";
        Restart = "on-failure";
      };
      Install.WantedBy = ["hyprland-session.target"];
    };
  };
}
