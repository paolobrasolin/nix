# tmux workspaces for coding agents: one tmux session per project folder, tabs
# inside it for nvim / agents / shells, and markers + notifications that say
# which workspace and tab needs you. Everything it needs is in this folder; how
# the pieces fit together: README.md here.
#
# A home-manager module for macOS (afplay, osascript, a notifier app in
# ~/Applications); import it and set programs.tmux-agent.enable. It adds its
# tmux lines after any others (lib.mkAfter), overriding their status bar, window
# titles and Alt+digit bindings.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.tmux-agent;
  terminal-notifier = pkgs.callPackage ./terminal-notifier.nix {};
  # The icon comes from the installed Claude app, not this public repo.
  claudeIcon = "/Applications/Claude.app/Contents/Resources/electron.icns";
  # home-manager's mkImpureConfigMerger, on its master since 2026-10 but in no
  # release yet: just this file, pinned. It needs only lib. From home-manager
  # 26.11 on, use lib.hm.generators.mkImpureConfigMerger and drop the fetch.
  hmGenerators = import (builtins.fetchurl {
    url = "https://raw.githubusercontent.com/nix-community/home-manager/2b13c9cb3aa20653e6f8ee0b7f8331a53ea9b0a9/modules/lib/generators.nix";
    sha256 = "1ng6x3vndjgw1rc75f5njckg7mr69rjhvhj62r1bwk80wmsr52kl";
  }) {inherit lib;};
  # Copied on its own, so editing other files doesn't change the activation.
  claudeHooks = builtins.path {
    path = ./claude-hooks.json;
    name = "claude-hooks.json";
  };
in {
  options.programs.tmux-agent = {
    enable = lib.mkEnableOption "tmux workspaces for coding agents";
    claudeProfiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [".claude"];
      example = [".dq/.claude" ".ag/.claude"];
      description = ''
        Claude Code config folders, relative to the home folder, whose
        settings.json gets the hooks (claude-hooks.json). Folders without a
        settings.json yet are skipped.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      extraConfig = lib.mkAfter (builtins.readFile ./tmux.conf);
      # tmux's own terminal type rather than home-manager's default "screen": it's
      # what the kit was tested with, and it supports more colours and features.
      terminal = "tmux-256color";
      # tmux's development branch, which calls itself next-3.9, for OSC 7501
      # program status (#{pane_program_state}), which the agent markers trust
      # over the hooks. It retires itself once pkgs.unstable ships 3.9 or newer.
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
      source = ./tmux-agent;
      executable = true;
    };

    # Claude Code's hooks that report agent state (claude-hooks.json), merged
    # into each profile's settings: Claude Code writes those files itself
    # (/config, permission answers), so they can't be links into the nix store.
    # The merge takes out every entry that calls tmux-agent, in any event, adds
    # the current ones, drops events left empty and keeps everything else.
    # mkImpureConfigMerger writes the result atomically, keeps the file's mode,
    # keeps the newer file if Claude Code writes it meanwhile, and fails the
    # switch rather than touch a file that isn't valid JSON. Running sessions
    # keep their hooks.
    home.activation.tmuxAgentClaudeHooks = lib.hm.dag.entryAfter ["writeBoundary"] (
      lib.concatMapStringsSep "\n" (profile: let
        path = "${config.home.homeDirectory}/${profile}/settings.json";
      in ''
        if [ -f ${lib.escapeShellArg path} ]; then
        ${hmGenerators.mkImpureConfigMerger {
          inherit pkgs path;
          format = "json";
          empty = "{}";
          staticSettings = claudeHooks;
          jqOperation = ''
            $dynamic | .hooks = (
              ((.hooks // {}) | map_values(map(select(tostring | contains("tmux-agent") | not)))) as $kept
              | reduce ($static.hooks | to_entries[]) as $e ($kept; .[$e.key] = (.[$e.key] // []) + $e.value)
              | with_entries(select(.value != []))
            )
          '';
        }}
        fi
      '')
      cfg.claudeProfiles
    );

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
  };
}
