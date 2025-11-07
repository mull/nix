{ lib, ... }:
{
  networking.hostName = lib.mkDefault "changeme";
  networking.networkmanager.enable = lib.mkDefault true;
  networking.firewall.enable = lib.mkDefault true;
}
