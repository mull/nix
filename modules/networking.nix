{ lib, ... }:
{
  networking.hostName = lib.mkDefault "changeme";
  networking.networkmanager.enable = lib.mkDefault true;
  networking.firewall.enable = lib.mkDefault true;
  programs.nm-applet.enable = true;
  networking.networkmanager.wifi.powersave = true;

  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  networking.firewall.trustedInterfaces = [ "docker0" ];

  networking.firewall.allowedTCPPorts = [ 3000 3001 8080 ];
  # extraCommands = ''
  #   iptables -A nixos-fw -i br-+ -j nixos-fw-accept
  # '';
}
