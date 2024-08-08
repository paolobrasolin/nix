{
  home.stateVersion = "24.05";
  home.username = "Brasolin";
  # home.homeDirectory = "/Users/Brasolin";
  # programs.home-manager.enable = true;
  # programs.ssh.enable = true;
  home.file."alacritty" = {
    target = ".alacritty.toml";
    text = ''
      [font]
      normal = { family = "Hack Nerd Font" }
      size = 16.0
    '';
  };
}
