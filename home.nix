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

    nautilus

    # Wayland desktop utilities
    mako # notification
    libnotify # provides notify-send
    waybar
    wofi # app launcher
    playerctl # media controls
    hyprcursor 
    phinger-cursors
    hypridle # automatic lock screen
    # swaybg # background for niri

    # dev tools
    lazygit

    # social
    signal-desktop

    # email
    evolution

    # the big distraction
    slack

    # matrix client
    fluffychat

    code-cursor
    zed-editor

    # spotify struggles with wayland
      (spotify.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ makeWrapper ];
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/spotify \
            --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
        '';
      }))

    ollama
  ];

  # set gnome nautilus as default file opener
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "nautilus.desktop" ];
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };

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

  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        text = "Lock";
        keybind = "l";
        action = "swaylock -efF";
      }
      {
        label = "logout";
        text = "Log out";
        keybind = "o";
        action = "niri msg action quit";
      }
      {
        label = "reboot";
        text = "Reboot";
        keybind = "r";
        action = "systemctl reboot";
      }
      {
        label = "shutdown";
        text = "Shutdown";
        keybind = "p";
        action = "systemctl poweroff";
      }
    ];
  };

  systemd.user.services.ollama = {
    Unit = {
      Description = "Ollama LLM server";
    };
    Service = {
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
      Restart = "on-failure";
    };
    Install = {
        WantedBy = [ "default.target" ];
    };
  };
}
