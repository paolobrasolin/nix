{}: {
  imports = [
    "${
      fetchTarball {
        url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
        sha256 = "0sz8njfxn5bw89n6xhlzsbxkafb6qmnszj4qxy2w0hw2mgmjp829";
      }
    }/modules/vscode-server/home.nix"
  ];

  services.vscode-server.enable = true;
}
