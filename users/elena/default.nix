{pkgs, lib, ...}: {
  home.stateVersion = "23.11";

  home.username = "elena";
  home.homeDirectory = "/home/elena";

  programs.home-manager.enable = true;
  #programs.ssh.enable = true;

  home.packages = with pkgs; [
    pkgs.unstable.google-chrome
    xclip
    pasystray
    libreoffice-qt
  ];

  programs.alacritty.enable = true;
  # xsession.windowManager.TODO = {};
  # home.packages = [pkgs.texliveFull];

  programs.vscode = {
    enable = true;
    # Ref: https://nixos.wiki/wiki/Visual_Studio_Code
    # extensions = with pkgs.vscode-extensions; [
    #   ms-vscode-remote.remote-ssh
    #   ms-vscode-remote.remote-containers
    # ];
  };

}
