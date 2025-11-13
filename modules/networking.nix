{ lib, ... }:
{
  networking.hostName = lib.mkDefault "changeme";
  networking.networkmanager.enable = lib.mkDefault true;
  networking.firewall.enable = lib.mkDefault true;
  programs.nm-applet.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
