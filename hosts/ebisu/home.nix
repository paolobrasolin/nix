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
      size = 20.0

      [bell]
      command = { program = "afplay", args = ["/System/Library/Sounds/Tink.aiff"] }

      # The rest serves the tmux workspaces setup (users/paolo/tmux-workspaces.nix).
      [window]
      # Left Option is Alt, for tmux's Alt+digit and Alt+a keys; right Option
      # still types the Italian layout's @ # [ ] { }.
      option_as_alt = "OnlyLeft"

      [keyboard]
      bindings = [
        # Shift+Enter sends Esc+Enter, which Claude Code reads as a newline even
        # inside tmux: tmux asks the terminal for xterm's extended keys, which
        # Alacritty doesn't implement, so a plain Shift+Enter arrives as Enter.
        { key = "Return", mods = "Shift", chars = "\u001b\r" },
        # Alt+Shift+3 types £, and Alacritty sends non-ASCII characters without
        # the Esc that marks Alt; send it explicitly so tmux sees Alt+£
        # (workspace 3). The other Alt+Shift+digits work as they are.
        { key = "3", mods = "Alt|Shift", chars = "\u001b£" },
      ]
    '';
  };
  home.packages = with pkgs; [
    # NOTE: we use colima instead of Docker Desktop as a runtime
    # Ref: https://www.tyler-wright.com/blog/using-colima-on-an-m1-m2-mac/
    # First startup:
    # * `softwareupdate --install-rosetta --agree-to-license`
    # * `colima start --arch aarch64 --vm-type=vz --vz-rosetta`
    # colima # NOTE: disabled — lima 1.2.2 is marked insecure/EOL in nixpkgs 25.11
    zathura
    texlab
    tmate
    unstable.devenv
    nodejs
    age
    # unstable.uv
    # postman
    bfg-repo-cleaner
    git-secret
    uv
    tree
  ];

  home.sessionPath = [
    "$HOME/mutable_node_modules/bin" # npm config set prefix '~/mutable_node_modules'
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      "~/.colima/ssh_config" # NOTE: colima isn't being particularly smart about it.
    ];
  };
}
