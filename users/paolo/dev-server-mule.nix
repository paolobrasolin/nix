{pkgs, ...}: {
  home.packages = with pkgs; [
    # LSPs
    dockerfile-language-server-nodejs # dockerfile
    lemminx # xml
    pyright # python # TODO: switch to pylyzer
    nodePackages.typescript-language-server # typescript
    rubyPackages.solargraph # ruby # TODO: switch to ruby-lsp
    tailwindcss-language-server # tailwind  # FIXME: vim on slim files
    texlab # tex

    # Formatters
    # nodePackages.prettier # ALOT # TODO: switch to biome
    black # python
    rufo # ruby
    sqlfluff # sql

    # Diagnostics and linters
    ruff # python
  ];
}
