{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # TODO: think about remote server on inari https://nixos.wiki/wiki/Visual_Studio_Code
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers
    ];
  };
}

