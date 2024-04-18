{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    ripgrep
    gcc # just to compile treesitter parsers
  ];

  programs.neovim = {
    enable = true;
    # package = pkgs.neovim-nightly;
    vimAlias = true;
    # plugins = [];
    # extraPackages = [];
    withNodeJs = false;
    withRuby = false;
    withPython3 = false;
  };

  home.file."./.config/nvim/" = {
    source = ./files/lazyvim;
    recursive = true;
  };
}
