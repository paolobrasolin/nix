# tmux workspaces for coding agents: one tmux session per project folder, tabs
# inside it for nvim / agents / shells, and markers + notifications that say
# which workspace and tab needs you. How the pieces fit together, including the
# part that lives outside nix (Claude Code hooks): files/tmux-workspaces/README.md
#
# Only ebisu imports this; kitsune and inari keep the plain tmux setup from
# interactive.nix.
{lib, ...}: {
  programs.tmux = {
    # The kit goes after interactive.nix's extraConfig, so on this host it
    # overrides that file's status bar, window titles and Alt+digit bindings.
    extraConfig = lib.mkAfter (builtins.readFile ./files/tmux-workspaces/tmux.conf);
    # tmux's own terminal type rather than home-manager's default "screen": it's
    # what the kit was tested with, and it supports more colours and features.
    terminal = "tmux-256color";
  };

  # Helper behind the key bindings (workspace picker, jump to agent, worktree
  # agent, Alt+Shift+digit) and the Claude Code hooks, which call this path.
  home.file.".config/tmux/bin/tmux-agent" = {
    source = ./files/tmux-workspaces/tmux-agent;
    executable = true;
  };

  # The status bar shows what timewarrior is tracking (`tmux-agent timew`), so
  # inside tmux the prompt leaves it out; it made the prompt wrap onto a second
  # line. Outside tmux the prompt still shows it.
  programs.starship.settings.custom.timewarrior.when = lib.mkForce ''[ -z "$TMUX" ] && timew'';

  # Plain `tmux` (no arguments) opens the workspace for the current folder, or
  # goes back to it if it's already open; inside tmux it switches to it.
  # With arguments (`tmux a`, `tmux ls`, ...) it's the real tmux.
  programs.zsh.initContent = ''
    tmux() {
      if (( $# == 0 )); then ~/.config/tmux/bin/tmux-agent open "$PWD"
      else command tmux "$@"; fi
    }
  '';
}
