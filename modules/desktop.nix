{ config, pkgs, lib, ... }:
{
  hardware.graphics.enable = true;

  programs.sway.enable = false;

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
  };

  # having libinput is useful for debugging
  environment.systemPackages = with pkgs; [
    libinput
  ];

  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd 'dbus-run-session sway'";
        user = "greeter";
      };
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
    ];
  };

}
