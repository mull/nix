{ config, pkgs, inputs, ... }:
{
  home.username = "mull";
  home.homeDirectory = "/home/mull";
  home.stateVersion = "25.05";

  programs.home-manager = {
    enable = true;
  };

  home.packages = with pkgs; [
    home-manager

    # Wayland desktop utilities
    mako # notification
    libnotify # provides notify-send
    waybar
    wofi # app launcher
    playerctl

    # dev tools
    lazygit

    # social
    signal-desktop
  ];

  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox_dark";
      editor.line-number = "relative";
      editor.cursorline = true;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
    };
  };

  programs.zed-editor = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland

      monitor = eDP-1, 2880x1920@120Hz, auto-left, 2.0
      monitor = DP-3, 2560x1440@59.95Hz, auto-right, 1.0

      exec-once = mako
      exec-once = waybar
      exec-once = systemctl --user import-environment PATH XDG_CURRENT_DESKTOP
      exec-once = systemctl --user restart xdg-desktop-portal.service

      $terminal = kitty

      $mainMod = SUPER
      bind = $mainMod, Return, exec, wofi
      bind = $mainMod, Space, exec, wofi
      bind = $mainMod, T, exec, $terminal
      bind = $mainMod, Q, killactive

      # Navigation
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      bind = $mainMod, F, fullscreen, 0

      # Workspace switching
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5

      # Brightness controls
      bind = , XF86MonbrightnessUp, exec, brightnessctl set 10%+
      bind = , XF86MonbrightnessDown, exec, brightnessctl set 10%-

      # Volume (requires wpctl)
      bindei = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bindei = ,XF86AudioLowerVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      # Media play buttons (requires playerctl)
      bindl = ,XF86AudioPrev, exec, playerctl previous
      bindl = ,XF86AudioNext, exec, playerctl next
      bindl = ,XF86AudioPause, exec, playerctl play-pause
      bindl = ,XF86AudioPlay, exec, playerctl play-pause

      



      # Appearance
      general {
        gaps_in = 4
        gaps_out = 4
        border_size = 1

        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)

        resize_on_border = true
        allow_tearing = false
        layout = dwindle
      }

      decoration {
        rounding = 10
        rounding_power = 2
        active_opacity = 1.0
        inactive_opacity = 0.9

        shadow {
          enabled = true
          range = 4
          render_power = 3
          color = rgba(1a1a1aee)
        }

        blur {
          enabled = true
          size = 3
          passes = 1
          vibrancy = 0.1696
        }
      }

      animations {
         enabled = yes, please :)
         # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
         bezier = easeOutQuint,0.23,1,0.32,1
         bezier = easeInOutCubic,0.65,0.05,0.36,1
         bezier = linear,0,0,1,1
         bezier = almostLinear,0.5,0.5,0.75,1.0
         bezier = quick,0.15,0,0.1,1
         animation = global, 1, 10, default
         animation = border, 1, 5.39, easeOutQuint
         animation = windows, 1, 4.79, easeOutQuint
         animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
         animation = windowsOut, 1, 1.49, linear, popin 87%
         animation = fadeIn, 1, 1.73, almostLinear
         animation = fadeOut, 1, 1.46, almostLinear
         animation = fade, 1, 3.03, quick
         animation = layers, 1, 3.81, easeOutQuint
         animation = layersIn, 1, 4, easeOutQuint, fade
         animation = layersOut, 1, 1.5, linear, fade
         animation = fadeLayersIn, 1, 1.79, almostLinear
         animation = fadeLayersOut, 1, 1.39, almostLinear
         animation = workspaces, 1, 1.94, almostLinear, fade
         animation = workspacesIn, 1, 1.21, almostLinear, fade
         animation = workspacesOut, 1, 1.94, almostLinear, fade
      }

      dwindle {
        pseudotile = true
        preserve_split = true
      }

      master {
        new_status = master
      }

      misc {
        force_default_wallpaper = 0
        disable_hyprland_logo = true
      }

      input {
        kb_layout = us

        # dont change focus when mouse hovers over a window
        # i prefer to click
        follow_mouse = 0

        natural_scroll = true
        # touchpad {
        #   natural_scoll = true
        # }
      }

    '';
  };

  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
    };
  };

}
