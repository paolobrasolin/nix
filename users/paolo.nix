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

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        host = "github.com";
        identityFile = "~/.ssh/github"; # TODO: is there a better way?
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Paolo Brasolin";
    userEmail = "paolo.brasolin@gmail.com";
  };

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
