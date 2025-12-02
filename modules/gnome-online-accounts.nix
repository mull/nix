{ config, pkgs, lib, ... }:
{
  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];
  programs.dconf.enable = true;

  services.gnome.gnome-online-accounts.enable = true;
  services.gnome.gnome-keyring.enable = true;

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
  };


  environment.systemPackages = with pkgs; [
    seahorse
    gnome-control-center
    # gnome-online-accounts-gtk
  ];
}
