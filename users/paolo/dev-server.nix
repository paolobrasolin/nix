{ test, pkgs, ... }: {
  home.packages = with pkgs; [
    ## LANGUAGE         TOOL
    /* nix              lsp              */ nil
    /* nix              formatter        */ alejandra
    /* nix              diagnostics      */ deadnix
    /* nix              diagnostics      */ statix
  ];
}
