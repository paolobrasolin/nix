# tmux workspaces for coding agents: one tmux session per project folder, tabs
# inside it for nvim / agents / shells, and markers + notifications that say
# which workspace and tab needs you. How the pieces fit together, including the
# part that lives outside nix (Claude Code hooks): files/tmux-workspaces/README.md
#
# Only ebisu imports this; kitsune and inari keep the plain tmux setup from
# interactive.nix.
{
  config,
  lib,
  pkgs,
  ...
}: let
  terminal-notifier = pkgs.callPackage ../../pkgs/terminal-notifier {};
  # The icon comes from the installed Claude app, not this public repo.
  claudeIcon = "/Applications/Claude.app/Contents/Resources/electron.icns";
in {
  programs.tmux = {
    # The kit goes after interactive.nix's extraConfig, so on this host it
    # overrides that file's status bar, window titles and Alt+digit bindings.
    extraConfig = lib.mkAfter (builtins.readFile ./files/tmux-workspaces/tmux.conf);
    # tmux's own terminal type rather than home-manager's default "screen": it's
    # what the kit was tested with, and it supports more colours and features.
    terminal = "tmux-256color";
    # tmux's development branch, which calls itself next-3.9, for OSC 7501
    # program status (#{pane_program_state}), which the agent markers trust over
    # the hooks. Here rather than in interactive.nix's release pin so it stays on
    # this host; it retires itself once pkgs.unstable ships 3.9 or newer.
    package = lib.mkIf (lib.versionOlder pkgs.unstable.tmux.version "3.9") (lib.mkForce (
      pkgs.unstable.tmux.overrideAttrs {
        version = "next-3.9";
        src = pkgs.fetchFromGitHub {
          owner = "tmux";
          repo = "tmux";
          rev = "c8def16706c8552017ad4b174ddf5b0feba6a1c5"; # master on 2026-11-18
          hash = "sha256-eIwa9CIL/SoNTPndcGcZDDbtgDW+QcogGCmTeTN0n84=";
        };
      }
    ));
  };

  # Helper behind the key bindings (workspace picker, jump to agent, worktree
  # agent, Alt+Shift+digit) and the Claude Code hooks, which call this path.
  home.file.".config/tmux/bin/tmux-agent" = {
    source = ./files/tmux-workspaces/tmux-agent;
    executable = true;
  };

  # Claude Code's hooks that report agent state (files/tmux-workspaces/
  # claude-hooks.json), merged into both profiles' settings: Claude Code writes
  # those files itself (/config, permission answers), so they can't be links
  # into the nix store. The merge replaces the entries that call tmux-agent and
  # keeps everything else; the file is rewritten in place (keeping its mode) only
  # when that changes something, and left alone if the profile has none yet.
  # Sessions already running don't pick up hook changes.
  home.activation.tmuxAgentClaudeHooks = lib.hm.dag.entryAfter ["writeBoundary"] ''
    for f in "$HOME/.dq/.claude/settings.json" "$HOME/.ag/.claude/settings.json"; do
      [ -f "$f" ] || continue
      if ! new=$(${pkgs.jq}/bin/jq --slurpfile kit ${./files/tmux-workspaces/claude-hooks.json} '
          .hooks = reduce ($kit[0].hooks | to_entries[]) as $e (.hooks // {};
            .[$e.key] = [(.[$e.key] // [])[] | select(tostring | contains("tmux-agent") | not)] + $e.value)
        ' "$f"); then
        warnEcho "tmux-agent: couldn't read $f as JSON, so its hooks were left alone"
        continue
      fi
      if [ "$new" != "$(cat "$f")" ]; then
        run sh -c 'printf "%s\n" "$1" > "$2"' _ "$new" "$f"
        noteEcho "tmux-agent: updated the Claude Code hooks in $f"
      fi
    done
  '';

  # The app tmux-agent posts desktop notifications with: a copy of
  # terminal-notifier with its own bundle id, named tmux-agent, with Claude's
  # icon (a notification's icon is always its sender's). A copy, re-signed ad
  # hoc, because macOS lets an app post notifications only from an Applications
  # folder, and home-manager only links apps. Rebuilt when the package or the
  # icon changes; without the Claude app it keeps terminal-notifier's icon.
  home.activation.tmuxAgentNotifier = lib.hm.dag.entryAfter ["writeBoundary"] ''
    app="$HOME/Applications/tmux-agent.app"
    stamp="${config.xdg.stateHome}/tmux-agent/notifier"
    want="${terminal-notifier} $([ -f ${lib.escapeShellArg claudeIcon} ] && /sbin/md5 -q ${lib.escapeShellArg claudeIcon})"
    if [ ! -d "$app" ] || [ "$(cat "$stamp" 2>/dev/null)" != "$want" ]; then
      plist="$app/Contents/Info.plist"
      run rm -rf "$app"
      run mkdir -p "$HOME/Applications" "$(dirname "$stamp")"
      run /usr/bin/ditto ${terminal-notifier}/Applications/terminal-notifier.app "$app"
      run chmod -R u+w "$app"
      run /usr/bin/plutil -replace CFBundleIdentifier -string fr.julienxx.oss.terminal-notifier.tmux-agent "$plist"
      run /usr/bin/plutil -replace CFBundleName -string tmux-agent "$plist"
      run /usr/bin/plutil -replace CFBundleDisplayName -string tmux-agent "$plist"
      if [ -f ${lib.escapeShellArg claudeIcon} ]; then
        run cp ${lib.escapeShellArg claudeIcon} "$app/Contents/Resources/Claude.icns"
        run /usr/bin/plutil -replace CFBundleIconFile -string Claude "$plist"
      fi
      run /usr/bin/codesign --force --sign - "$app"
      run /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
      run sh -c 'printf "%s\n" "$1" > "$2"' _ "$want" "$stamp"
    fi
  '';

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
