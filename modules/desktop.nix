{ config, pkgs, lib, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.dbus.enable = true;

  programs.sway.enable = true;
  programs.hyprland.enable = true;


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
        default = [ "hyprland" "gtk" ];
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
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember";
        user = "greeter";
      };
    };
  };
  services.udev.packages = [ pkgs.brightnessctl ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      jetbrains-mono
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      font-awesome
      material-design-icons
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      # hinting = "slight";
      # subpixelRendering = "rgb";
      # 
      defaultFonts = {
        monospace = [ "JetBrains Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  programs.firefox = {
    enable = true;

    policies = {
      # Extensions!
      ExtensionSettings = {
        # blocks all addons except the ones specified below
        # dunno if we keep this
        "*".installation_mode = "blocked";

        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

}
