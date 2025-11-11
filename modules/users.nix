{ config, pkgs, ... }:

{
  users.users.mull = {
    isNormalUser = true;
    description = "emil";
    extraGroups = ["networkmanager" "wheel" "mull" "video" "input"];
  };

}
