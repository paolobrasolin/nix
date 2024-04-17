{ pkgs, ... }: {
  home.packages = with pkgs; [
    lunarvim
    hcloud
    # ripgrep fzf fd zoxide
    timewarrior
    gnumake
    zip unzip
    gdown
    htop
    sshuttle
    sshfs
    jq
    go-task
    lazydocker
    mkcert
  ];

  # TODO: experiment with these
  # nix-index.enable = true;
  # nix-index.enableZshIntegration = true;
  # nix-index-database.comma.enable = true;
  # fzf.enable = true;
  # fzf.enableZshIntegration = true;
  # lsd.enable = true;
  # lsd.enableAliases = true;
  # zoxide.enable = true;
  # zoxide.enableZshIntegration = true;
  # broot.enable = true;
  # broot.enableZshIntegration = true;
  # direnv.enable = true;
  # direnv.enableZshIntegration = true;
  # direnv.nix-direnv.enable = true;

  # TODO: consider gitui, which should be faster
  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Paolo Brasolin";
    userEmail = "paolo.brasolin@gmail.com";
    delta.enable = true;
    delta.options = {
      line-numbers = true;
      side-by-side = true;
      navigate = true;
    };
    extraConfig = {
      # Automatically handle !fixup and !squash commits -- see https://thoughtbot.com/blog/autosquashing-git-commits
      rebase.autosquash = "true";
      # Improve merge conflicts style showing base -- see https://ductile.systems/zdiff3/
      merge.conflictstyle = "zdiff3";
      # Different color for moves in diffs.
      diff.colorMoved = "default";
      # Default branch name.
      init.defaultBranch = "main";
      # Help with autocorrect but ask for permission.
      help.autocorrect = "prompt";
      # Use ISO dates.
      log.date = "iso";
      # Probably easier diffs when permuting functions.
      diff.algorithm = "histogram";
      # Sort branches by last commit.
      branch.sort = "-committerdate";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    history.ignoreDups = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      t = "timew";
      vim = "lvim";
      inari = "task -d ~/nix/tasks/inari";
      snix = "sudo nixos-rebuild switch";
    };
    initExtra = ''
      # Usage: ssh-L [user@]host ports...
      ssh-L () { ssh -vN $(printf ' -L %1$s:localhost:%s' ''${@:2}) $1 }
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      # username.show_always = true;
      # hostname.ssh_only = false;
      memory_usage.disabled = false;
      status.disabled = false;
      sudo.disabled = false;
      docker_context.only_with_files = false;
      custom.hcloud_context = {
        command = "hcloud context active";
        when = true; # "command -v hcloud";
        style = "bold red";
        symbol = " ";
      };
      custom.timewarrior = {
        command = let
          jq_script = ''
            .tags |= sort_by(length) |
            {
              tags: .tags | join("/"),
              duration: (now - (.start | strptime("%Y%m%dT%H%M%SZ") | mktime)) | strftime("%H:%M")
            } |
            "\(.tags) \(.duration)"
          '';
        in "timew get dom.active.json | jq -r '${jq_script}'";
        when = "timew";
        symbol = " ";
      };
    };
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0; # NOTE: this would be very annoying when using vim
    keyMode = "vi";
    mouse = true;
    extraConfig = ''
      # This fixes true color in tmux/alacritty/neovim; for reference see https://unix.stackexchange.com/a/568263 and https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
      set -ag terminal-overrides ",alacritty:RGB"
      # Quick window selection
      bind-key -n M-0 select-window -t 0
      bind-key -n M-1 select-window -t 1
      bind-key -n M-2 select-window -t 2
      bind-key -n M-3 select-window -t 3
      bind-key -n M-4 select-window -t 4
      bind-key -n M-5 select-window -t 5
      bind-key -n M-6 select-window -t 6
      bind-key -n M-7 select-window -t 7
      bind-key -n M-8 select-window -t 8
      bind-key -n M-9 select-window -t 9
    '';
  };

  home.file.".editorconfig".source = ./files/editor_config.ini;
  home.file.".config/lvim/config.lua".source = ./files/lvim_config.lua;
}
