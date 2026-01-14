{ config, pkgs, ... }:

{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = [
    pkgs.neofetch
    pkgs.ripgrep
  ];
}
