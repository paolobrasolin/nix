{ test, pkgs, ... }: {
  home.packages = with pkgs; [

    ## LANGUAGE         TOOL
    /* lua              lsp              */ lua-language-server
    /* lua              formatter        */ stylua
    /* lua              diagnostics      */ selene
    /* nix              lsp              */ nil
    /* nix              formatter        */ alejandra
    /* nix              diagnostics      */ deadnix
    /* nix              diagnostics      */ statix
    /* html, css, json  lsp              */ vscode-langservers-extracted
    /* yaml             lsp              */ yaml-language-server
    /* markdown         lsp              */ marksman
    /* shell            lsp              */ nodePackages.bash-language-server
    /* shell            diagnostics      */ shellcheck
    /* shell            formatter        */ shfmt
  ];
}
