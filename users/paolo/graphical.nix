{ pkgs, ... }: {
  home.packages = with pkgs; [
    google-chrome
    telegram-desktop
    dmenu
    alacritty
    xclip
    pasystray
    zathura
    feh
  ];

  home.file.".config/i3/config".source = ./files/i3_config.txt;
  # home.file.".config/i3status/config".source = ./files/i3status_config.txt;
}
