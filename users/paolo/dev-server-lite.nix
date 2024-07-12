{pkgs, ...}: {
  home.packages = with pkgs; [
    # LSPs
    lua-language-server # lua
    marksman # markdown
    nil # nix
    nodePackages.bash-language-server # shell
    vscode-langservers-extracted # html, css, json
    yaml-language-server # yaml

    texlab

    # Formatters
    alejandra # nix
    shfmt # shell
    stylua # lua

    # Diagnostics and linters
    deadnix # nix
    selene # lua
    shellcheck # shell
    statix # nix
  ];
}
