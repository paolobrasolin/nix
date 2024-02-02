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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    history.ignoreDups = true;
    historySubstringSearch.enable = true;
    prezto = {
      enable = true;
      prompt = {
        showReturnVal = true;
        theme = "pure";
      };
    };
    shellAliases = {
      snix = "sudo nixos-rebuild switch";
    };
  };
}
