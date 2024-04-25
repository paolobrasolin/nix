{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    ripgrep
    fzf
    gcc # required for :TSInstall
    tree-sitter # required for :TSInstallFromGrammar
  ];

  programs.neovim = {
    enable = true;
    # package = pkgs.neovim-nightly;
    vimAlias = true;
    # plugins = [];
    # extraPackages = [];
    withNodeJs = true; # required for :TSInstallFromGrammar
    withRuby = false;
    withPython3 = false;
  };

  home.file."./.config/nvim/" = {
    source = ./files/lazyvim;
    recursive = true;
  };
}
