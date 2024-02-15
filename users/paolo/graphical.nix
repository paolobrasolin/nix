{ pkgs, ... }: {
  home.packages = with pkgs; [
    google-chrome
    telegram-desktop
    dmenu
    xclip
    pasystray
    zathura
    feh
    libreoffice-qt
  ];

  programs.alacritty.enable = true;

  home.file.".config/i3/config".source = ./files/i3_config.txt;
  # home.file.".config/i3status/config".source = ./files/i3status_config.txt;
}
