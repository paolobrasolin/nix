{pkgs, ...}: {
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
  home.packages = with pkgs; [
    # NOTE: we use colima instead of Docker Desktop as a runtime
    # Ref: https://www.tyler-wright.com/blog/using-colima-on-an-m1-m2-mac/
    # First startup:
    # * `softwareupdate --install-rosetta --agree-to-license`
    # * `colima start --arch aarch64 --vm-type=vz --vz-rosetta`
    colima
  ];

  programs.ssh = {
    enable = true;
    includes = [
      "~/.colima/ssh_config" # NOTE: colima isn't being particularly smart about it.
    ];
    matchBlocks."github" = {
      host = "github.com";
      identitiesOnly = true;
      identityFile = [
        "~/.ssh/pb-paolo_at_ebisu"
        "~/.ssh/dq-paolo_at_ebisu"
      ];
    };
  };
}
