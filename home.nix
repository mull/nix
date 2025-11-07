{ config, pkgs, ... }:
{
  home.username = "mull";
  home.homeDirectory = "/home/mull";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox_dark";
      editor.line-number = "relative";
      editor.cursorline = true;
    };
  };

}
