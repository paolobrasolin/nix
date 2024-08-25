{
  imports = [
    "${
      fetchTarball {
        url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
        sha256 = "1rq8mrlmbzpcbv9ys0x88alw30ks70jlmvnfr2j8v830yy5wvw7h";

      }
    }/modules/vscode-server/home.nix"
  ];

  services.vscode-server.enable = true;
}
