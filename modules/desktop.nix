{ config, pkgs, lib, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.dbus.enable = true;

  programs.sway.enable = true;
  # programs.hyprland.enable = true;
  programs.niri.enable = true;

  # fw31 touchpad
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;  
      tapping = true;
      disableWhileTyping = true;
      scrollMethod  = "twofinger";
      accelProfile = "adaptive";
    };
  };
  # libinput exposes the touchpad both as a mouse and a touchpad
  services.udev.extraRules = ''
    # Ignore the "Mouse" node
    SUBSYSTEM=="input", ATTRS{name}=="PIXA3854:00 093A:0274 Mouse", ENV{LIBINPUT_IGNORE_DEVICE}="1"

    # Treat the "real" node ia touchpad
    SUBSYSTEM=="input", ATTRS{name}=="PIXA3854:00 093A:0274 Touchpad", \
      ENV{ID_INPUT_TOUCHPAD}="1", ENV{ID_INPUT_MOUSE}="0"
  '';


  xdg.autostart.enable = true;
  xdg.portal = {
    enable = true;
    # AI suggests keeping the GTK portal for some apps
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      hyprland = {
        default = ["niri" "hyprland" "gtk" ];
      };
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    # having libinput is useful for debugging
    libinput
    # brightness adjustment
    brightnessctl
    # portalllls
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    # swaylock
    swayidle
    swaylock-effects
    wlogout
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks";
        user = "greeter";
      };
    };
  };
  services.udev.packages = [ pkgs.brightnessctl ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      font-awesome
      material-design-icons
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      # hinting = "slight";
      # subpixelRendering = "rgb";
      # 
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  security.pam.services.swaylock = { };

  # services.swayidle = {
  #   enable = true;

  #   timeouts = [
  #     {
  #       timeout = 15;
  #       command = "brightnessctl -sd framework_laptop::kbd_backlight set 0";
  #       resumeCommand = "brightnessctl -sd framework_laptop::kbd_backlight set 75";
  #     }
  #     {
  #       timeout = 30;
  #       command = "swaylock -efF";
  #     }
  #   ];

  #   events = [
  #     {
  #       event = "lock";
  #       command = "swaylock -efF";
  #     }
  #     {
  #       event = "before-sleep";
  #       command = "swaylock -efF";
  #     }
  #   ];
  # };
  systemd.user.services.swayidle = {    
    description = "Idle manager for Wayland (Niri + swaylock)";
    wantedBy    = [ "graphical-session.target" ];
    partOf      = [ "graphical-session.target" ];

    unitConfig = {
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    serviceConfig = {
      Type = "simple";
      # Make sure PATH includes system binaries and your user profile
      # Environment = "PATH=/run/current-system/sw/bin:/home/mull/.nix-profile/bin";

      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w \
          timeout 15  'brightnessctl -sd framework_laptop::kbd_backlight set 0' \
          resume      'brightnessctl -sd framework_laptop::kbd_backlight set 75' \
          timeout 30  '/home/mull/nix/config/scripts/conditional-swaylock.sh' \
          timeout 90  'swaylock -efF'
      '';

      Restart = "always";
    };
  };


  programs.firefox = {
    enable = true;

    policies = {
      # Extensions!
      ExtensionSettings = {
        # "*".installation_mode = "blocked";

        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # vimium
        # "d7742d87-e61d-4b78-b8a1-b469842139fa" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium_ff/latest.xpi";
        #   installation_mode = "force_installed";
        # };
      };
    };
  };

}
