{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "mull-fw13";

  # Boot loader & fs
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  powerManagement.enable = true;

  services.fwupd.enable = true;

  environment.systemPackages = [
    pkgs.fw-ectool
    pkgs.lm_sensors
  ];
}
