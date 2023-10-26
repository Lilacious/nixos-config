## dependent on hyprland flake input
{ pkgs, config, hyprland, ... }:
{
  # Dependencies
  #
  imports = [
    hyprland.homeManagerModules.default
    ./eww.nix
    ./dunst.nix
    ./themes.nix
    ./swaylock.nix
    ./anyrun.nix
  ];
  home.packages = with pkgs; [
    eww-wayland

    ## qt libraries
    libsForQt5.qt5.qtwayland
    qt6.qtwayland

    ## Clipboard manager
    cliphist
    grim
    slurp
    xdg-desktop-portal-hyprland
    
    ## Wallpaper utilities
    waypaper
    swaybg
    swww

    ## Colour picker
    hyprpicker

    ## Other
    wirelesstools # Eww script dependency
    libsForQt5.polkit-kde-agent  # Authentication agent
    xorg.xhost
  ];

  # Hyprland Config
  #
  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;
    
    extraConfig =  ''
      input {
        kb_layout = de
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =

        follow_mouse = 1

        touchpad {
          natural_scroll = false # not natural at all :/
        }

        sensitivity = 0.8 # -1.0 - 1.0, 0 means no modification.
      }

      device:synaptics-tm3276-022 {
        sensitivity = 0.3
      }
      device:tpps/2-ibm-trackpoint {
        sensitivity = 0.5
      }
      gestures {
        workspace_swipe = true
        workspace_swipe_forever = true
      }
      misc {
        disable_autoreload = true
        vfr = true
      }

      monitor=,highres,auto,1

      general {
        # See https://wiki.hyprland.org/Configuring/Variables/
        gaps_in = 2.5
        gaps_out = 5
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg # defaultrgba(E6D7FFFF)
        col.inactive_border = rgba(595959aa)

        layout = dwindle
      }

      decoration {
        rounding = 10
        active_opacity = 1
        inactive_opacity = 1
        fullscreen_opacity = 1
        drop_shadow = false
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
        blur {
          enabled = false
          size = 3
          passes = 1
          new_optimizations = true
        }
      }

      animations {
        enabled = true

        # see https://wiki.hyprland.org/Configuring/Animations/

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }

      dwindle {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/
        pseudotile = true
        preserve_split = true # you probably want this
      }

      master {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ 
        new_is_master = true
        inherit_fullscreen = true
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing
      #device:epic-mouse-v1 {
      #  sensitivity = -0.5
      #}

      # Example windowrule v1
      # windowrule = float, ^(alacritty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/
      windowrulev2 = float,title:^(.*Authentication.*)$
      
      $Mod = SUPER
      bind = $Mod, Return, exec, alacritty
      bind = $Mod, W, killactive,
      bind = $Mod, B, exec, firefox
      bind = $Mod, Space, exec, anyrun --plugins $ANYRUNAPPLICATIONS --plugins $ANYRUNSHELL
      bind = $Mod, M, fullscreen, 1
      bind = CONTROLALT, Delete, exit,
      bind = $Mod, Print, exec, grim -g "$(slurp)" ~/Pictures/Screenshots/"$(date +%Y%m%d-%H%M%S)".png
      bind = $Mod, F, togglefloating,
      bind = $Mod, P, pseudo, # dwindle
      bind = $Mod, J, togglesplit, # dwindle

      # Move focus with mainMod + arrow keys
      bind = $Mod, left, movefocus, l
      bind = $Mod, right, movefocus, r
      bind = $Mod, up, movefocus, u
      bind = $Mod, down, movefocus, d

      # Volume and microphone control
      binde = ,XF86AudioRaiseVolume, exec, amixer -Mq set Master 5%+ unmute
      binde = ,XF86AudioLowerVolume, exec, amixer -Mq set Master 5%- unmute
      bind = ,XF86AudioMute, exec, amixer -q set Master toggle
      bind = ,XF86AudioMicMute, exec, amixer set Capture toggle

      # Backlight control
      # set min brightness to 10 with "light -N 10"
      bind= ,XF86MonBrightnessUp, exec, light -A 5
      bind= ,XF86MonBrightnessDown, exec, light -U 5

      # Switch workspaces with mainMod + [0-9]
      bind = $Mod, 1, workspace, 1
      bind = $Mod, 2, workspace, 2
      bind = $Mod, 3, workspace, 3
      bind = $Mod, 4, workspace, 4
      bind = $Mod, 5, workspace, 5
      bind = $Mod, 6, workspace, 6
      bind = $Mod, 7, workspace, 7
      bind = $Mod, 8, workspace, 8
      bind = $Mod, 9, workspace, 9
      bind = $Mod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT
      bind = $Mod SHIFT, 1, movetoworkspace, 1
      bind = $Mod SHIFT, 2, movetoworkspace, 2
      bind = $Mod SHIFT, 3, movetoworkspace, 3
      bind = $Mod SHIFT, 4, movetoworkspace, 4
      bind = $Mod SHIFT, 5, movetoworkspace, 5
      bind = $Mod SHIFT, 6, movetoworkspace, 6
      bind = $Mod SHIFT, 7, movetoworkspace, 7
      bind = $Mod SHIFT, 8, movetoworkspace, 8
      bind = $Mod SHIFT, 9, movetoworkspace, 9
      bind = $Mod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scroll
      bind = $Mod, mouse_down, workspace, e+1
      bind = $Mod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $Mod, mouse:272, movewindow
      bindm = $Mod, mouse:273, resizewindow

      # Laptop lid switch
      bindl=,switch:Lid Switch,exec,swaylock

      exec-once=eww open main
      exec-once = nm-applet --indicator & disown
      exec-once = dunst
      exec-once = ${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      exec-once = xhost +SI:localuser:root
      exec-once = swaybg -m fill -i ~/Pictures/Wallpaper/default.png
      env = XDG_CURRENT_DESKTOP, Hyprland
      env = XDG_SESSION_TYPE, wayland
      env = XDG_SESSION_DESKTOP, Hyprland
     '';
  };
}
