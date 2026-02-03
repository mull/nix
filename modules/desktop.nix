{ config, pkgs, lib, ... }:
{
  hardware.graphics = {
    enable = true;
  };
  services.dbus.enable = true;

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

    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # having libinput is useful for debugging
    libinput
    # brightness adjustment
    brightnessctl
    # portalllls
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk

    # recording screen
    obs-studio

    # swaylock
    # swayidle
    # swaylock-effects
    wlogout

    xwayland-satellite

    # TODO: move this to modules/networking
    networkmanagerapplet
  ];

  services.xserver = {
    enable = true;
  };
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
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

  # security.pam.services.swaylock = { };

  # systemd.user.services.swayidle = {    
  #   description = "Idle manager for Wayland (Niri + swaylock)";
  #   wantedBy    = [ "graphical-session.target" ];
  #   partOf      = [ "graphical-session.target" ];

  #   unitConfig = {
  #     After = [ "graphical-session.target" ];
  #     ConditionEnvironmnet = "XDG_CURRENT_DESKTOP=niri";
  #   };

  #   serviceConfig = {
  #     Type = "simple";

  #     ExecStart = ''
  #       ${pkgs.swayidle}/bin/swayidle -d -w \
  #         timeout 15    '${pkgs.brightnessctl}/bin/brightnessctl -sd framework_laptop::kbd_backlight set 0' \
  #         resume        '${pkgs.brightnessctl}/bin/brightnessctl -sd framework_laptop::kbd_backlight set 75' \
  #         timeout 30    '/home/mull/nix/config/scripts/conditional-swaylock.sh' \
  #         timeout 180   '${pkgs.swaylock-effects}/bin/swaylock -efF'
  #     '';

  #     Restart = "always";
  #   };
  # };


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
