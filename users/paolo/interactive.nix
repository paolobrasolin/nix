{ pkgs, ... }: {
  home.packages = with pkgs; [
    lunarvim
    hcloud
    alejandra
    # ripgrep fzf fd zoxide
    timetrap
    gnumake
  ];

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
    lfs.enable = true;
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

  home.file.".editorconfig".source = ./files/editor_config.ini;
  home.file.".config/lvim/config.lua".source = ./files/lvim_config.lua;
}
