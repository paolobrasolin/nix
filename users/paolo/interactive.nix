{ pkgs, ... }: {
  home.packages = with pkgs; [
    lunarvim
    hcloud
    alejandra
    # ripgrep fzf fd zoxide
  ];

  programs.ssh = {
    enable = true;
    # matchBlocks = {
    #   "github.com" = {
    #     user = "git";
    #     host = "github.com";
    #     identityFile = "~/.ssh/id_ed25519"; # TODO: is there a better way?
    #   };
    #   "hetzner" = {
    #     user = "root";
    #     host = "195.201.130.78";
    #     identityFile = "~/.ssh/id_ed25519"; # TODO: is there a better way?
    #   };
    # };
  };

  # TODO: experiment with these
  # nix-index.enable = true;
  # nix-index.enableZshIntegration = true;
  # nix-index-database.comma.enable = true;
  # fzf.enable = true;
  # fzf.enableZshIntegration = true;
  # lsd.enable = true;
  # lsd.enableAliases = true;
  # zoxide.enable = true;
  # zoxide.enableZshIntegration = true;
  # broot.enable = true;
  # broot.enableZshIntegration = true;
  # direnv.enable = true;
  # direnv.enableZshIntegration = true;
  # direnv.nix-direnv.enable = true;

  programs.git = {
    enable = true;
    userName = "Paolo Brasolin";
    userEmail = "paolo.brasolin@gmail.com";
    delta.enable = true;
    delta.options = {
      line-numbers = true;
      side-by-side = true;
      navigate = true;
    };
    extraConfig = {
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
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

  home.file.".config/lvim/config.lua".source = ./files/lvim_config.lua;
}
