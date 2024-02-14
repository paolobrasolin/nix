{ pkgs, ... }: {
  home.packages = with pkgs; [
    lunarvim
    hcloud
    alejandra
    # ripgrep fzf fd zoxide
    timetrap sqlite
    gnumake
    zip unzip
    gdown
    htop
    sshuttle
    sshfs
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

  programs.lazygit.enable = true;
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
      # NOTE: the path of the requisite is the same on both machines, you don't need to ssh to get the value of --python; cool!
      # TODO: find a nix way to get --python
      # TODO: this should only be on kitsune tbh
      tonneru = "sshuttle --python=\"$(nix-store --query $(which sshuttle) --requisites | grep -m1 'python3-.*-env')/bin/python\" -r paolo@inari $(hcloud server ip inari)";
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

  programs.tmux.enable = true;

  home.file.".editorconfig".source = ./files/editor_config.ini;
  home.file.".config/lvim/config.lua".source = ./files/lvim_config.lua;
}
