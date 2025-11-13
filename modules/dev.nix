{ config, pkgs, ... }:
 {
  virtualisation.docker.enable = true;
  users.users.mull.extraGroups  = [ "docker" ];
}
