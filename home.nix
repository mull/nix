{ config, pkgs, ... }:
{
  home.username = "mull";
  home.homeDirectory = "/home/mull";
  home.stateVersion = "25.05";

  # Enable font cache for user session
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    home-manager
  ];

  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox_dark";
      editor.line-number = "relative";
      editor.cursorline = true;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
    };
  };
}
