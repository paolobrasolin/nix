{ test, pkgs, ... }: {
  home.packages = with pkgs; [
    # texlive.combined.scheme-full

    ## LANGUAGE         TOOL
    /* xml              lsp              */ lemminx
    /* dockerfile       lsp              */ dockerfile-language-server-nodejs
    /* typescript       lsp              */ nodePackages.typescript-language-server
    /* tex              lsp              */ texlab
    # /* many             formatter        */ nodePackages.prettier # TODO: switch to biome
    /* python           lsp              */ nodePackages.pyright # TODO: switch to pylyzer
    /* python           formatter        */ black
    /* python           fmt, diagnostics */ ruff
    /* ruby             lsp              */ rubyPackages.solargraph # TODO: switch to ruby-lsp
    /* ruby             formatter        */ rufo
    /* tailwind         lsp              */ tailwindcss-language-server # FIXME: vim on slim files
  ];
}
