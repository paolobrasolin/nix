{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    # Ref: https://nixos.wiki/wiki/Visual_Studio_Code
    extensions = with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers
    ];
  };
}
