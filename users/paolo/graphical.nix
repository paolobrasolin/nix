{ pkgs, ... }: {
  home.packages = with pkgs; [
    google-chrome
    dmenu
    alacritty
  ];
}
