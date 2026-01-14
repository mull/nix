{ config, pkgs, inputs, ... }:
{
  home.username = "mull";
  home.homeDirectory = "/home/mull";
  home.stateVersion = "25.05";

  programs.home-manager = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
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

    # local LLMs
    ollama

    # Bitwarden for PWs
    bitwarden-desktop
    # Client uses
    keepassxc

    android-studio
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
    keybindings = {
      "f1" = "launch --cwd=current";
      "f2" = "launch --cwd=current --type=tab";
    };
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

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
  };

  programs.zsh = {
    enable = true;
    # enableCompletions = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    history = {
      size = 100000;
      save = 100000;
      share = true;
      extended = true;
    };

    shellAliases = {
      ll = "ls -alf";
      la = "ls -a";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
      ];
    };

    initExtra = ''
      source "${config.home.homeDirectory}/external-installs/google-cloud-sdk/path.zsh.inc"
      source "${config.home.homeDirectory}/external-installs/google-cloud-sdk/completion.zsh.inc"
    '';

    # initextra = ''
    #    # --- Vim mode for shell editing ---
    #   bindkey -v

    #   # Up/down history search (works in vim mode too)
    #   autoload -Uz up-line-or-beginning-search
    #   autoload -Uz down-line-or-beginning-search
    #   zle -N up-line-or-beginning-search
    #   zle -N down-line-or-beginning-search
    #   bindkey '^[[A' up-line-or-beginning-search
    #   bindkey '^[[B' down-line-or-beginning-search

    #   # better completion menu
    #   autoload -uz compinit
    #   compinit

    #   zstyle ':completion:*' menu select
    #   zstyle ':completion:*' matcher-list 'm:{a-z}={a-z}' 'r:|[._-]=* r:|=*'

    #   # some sane options
    #   setopt autocd          # `cd` just by typing dir name
    #   setopt correct         # spelling correction for commands
    #   setopt notify          # report background job status asap
    #   setopt hist_ignore_all_dups
    #   setopt share_history   # share history across sessions
    # '';
  };
}
