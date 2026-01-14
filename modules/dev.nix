{ config, pkgs, ... }:
 {
  virtualisation.docker = {
    enable = true;
    # sudo mkdir /home/docker-data
    # sudo chown root:root /home/docker-data
    extraOptions = "--data-root=/home/docker-data";
     daemon.settings = {
      # Ensure bridge network is properly configured
      bip = "172.17.0.1/16";
    };
  };
  users.users.mull.extraGroups  = [ "docker" "kvm"];
}
