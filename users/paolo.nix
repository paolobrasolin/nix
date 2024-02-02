{ config, pkgs, ... }: {
  home.stateVersion = "23.11";

  home.username = "paolo";
  home.homeDirectory = "/home/paolo";

  home.packages = with pkgs; [
    google-chrome
    dmenu
    alacritty
  ];
  
  programs.home-manager.enable = true;
}
