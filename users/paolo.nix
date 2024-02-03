{ config, pkgs, ... }: {
  home.stateVersion = "23.11";

  home.username = "paolo";
  home.homeDirectory = "/home/paolo";

  home.packages = with pkgs; [
    google-chrome
    dmenu
    alacritty
    lunarvim
    xclip
    telegram-desktop
    # ripgrep fzf fd zoxide
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
      "hetzner" = {
        user = "root";
        host = "195.201.130.78";
        identityFile = "~/.ssh/hetzner"; # TODO: is there a better way?
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
    shellAliases = {
      vim = "lvim";
      snix = "sudo nixos-rebuild switch";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      # username.show_always = true;
      # hostname.ssh_only = false;
      memory_usage.disabled = false;
      status.disabled = false;
      sudo.disabled = false;
    };
  };

  #home.file.".config/lvim/config.lua".source = ./lvim_config.lua;
}
