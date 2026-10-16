# tmux workspaces

One tmux session per project folder (a *workspace*), tabs inside it for nvim,
coding agents and shells, and markers plus notifications that say which
workspace and which tab needs you. Plain tmux 3.8, no plugins.

```
▌1 dogup_web ▎2 colloquia ▌3 iac ▎4 tiomuxolo             dq/pd#232 01:42   <- workspaces
▎1 nvim ▌2 claude ▎3 zsh                                                      <- tabs in "colloquia"
```

A thick edge and a coloured name show an agent's state: pink-red, it's waiting
on you; green, it's done (clears when you look at it); a light grey edge, it's
working. Tabs keep their width, so nothing moves when states change.
Each workspace's edge is coloured by folder (`~/dq` orange, `~/pb` purple,
`~/ag` cyan) unless an agent there is busy or needs you. Top right: what timewarrior is tracking, as in the prompt (`tmux-agent
timew`). The keys are listed at the top of `tmux.conf`.

To start, `cd` into a project and run `tmux`: it opens that folder's
workspace, or goes back to it if it's already open. Inside tmux, `C-b W` opens
any other project.

Built and tested in `~/pb/tiomuxolo` (October 2026); its history shows how the
original kit was adapted to this machine.

## How the pieces fit

| piece | defined in | ends up as |
|---|---|---|
| tmux config | `tmux.conf` here, added by `users/paolo/tmux-workspaces.nix` after `interactive.nix`'s tmux lines | the end of `~/.config/tmux/tmux.conf` |
| terminal type `tmux-256color` | `users/paolo/tmux-workspaces.nix` | `default-terminal` in the same file |
| helper script | `tmux-agent` here | `~/.config/tmux/bin/tmux-agent` |
| plain `tmux` opens the current folder's workspace | `users/paolo/tmux-workspaces.nix` | a `tmux` function in `~/.zshrc` |
| left Option as Alt, Shift+Enter, Alt+Shift+3 | `hosts/ebisu/home.nix` | `~/.alacritty.toml` |
| Claude Code hooks | `claude-hooks.json` here, **not installed by nix** | merged into `~/.dq/.claude/settings.json` and `~/.ag/.claude/settings.json` |

Only ebisu imports the module (`flake.nix`); kitsune and inari keep the plain
tmux setup from `interactive.nix`.

How a marker gets there: Claude Code runs a hook → `tmux-agent state
working|waiting|done|clear` sets the pane option `@agent` → both status rows
and the `C-b w` tree show it. On *waiting* and *done* the helper also rings the
bell (flags the tab), shows a message on other tmux clients, and sends a macOS
notification when no tmux client has focus.

## Environment and direnv

The tmux server copies the environment of the shell that starts it, once, and
every tab starts from that copy. Each tab is a fresh login shell, so the direnv
hook loads its own folder's `.envrc` and undoes any other project's: tabs
behave like separate terminal windows. Popups and `run-shell` commands (the
`C-b W` picker, the `C-b A` prompt) don't run the hook, so when `tmux` starts
the server from a folder with direnv loaded (`~/dq/.envrc` exports API tokens),
`tmux-agent open` starts it through `direnv exec /`, which unloads that first.
Starting tmux any other way (`tmux new`, …) skips this.

## Claude Code hooks

They live outside nix because Claude Code writes its own settings files
(`/config`, permission answers), so they can't be read-only links into the nix
store. Both profiles get them; plain `claude` (`~/.claude`) doesn't. To install
them, or reinstall after changing `claude-hooks.json` (safe to rerun: it
replaces its own entries and keeps everything else):

```sh
cd ~/pb/nix/users/paolo/files/tmux-workspaces
for f in ~/.dq/.claude/settings.json ~/.ag/.claude/settings.json; do
  cp -p "$f" "$f.bak.$(date +%Y%m%d-%H%M%S)"
  jq --slurpfile kit claude-hooks.json '
    .hooks = reduce ($kit[0].hooks | to_entries[]) as $e (.hooks // {};
      .[$e.key] = [(.[$e.key] // [])[] | select(tostring | contains("tmux-agent") | not)] + $e.value)
  ' "$f" > "$f.new" && cat "$f.new" > "$f" && rm "$f.new"
done
```

Claude Code reads hooks when a session starts, so sessions already running
don't report their state.

## Changing it

- Edit `tmux.conf` or `tmux-agent` here, `snix`, then reload a running tmux
  with `tmux source-file ~/.config/tmux/tmux.conf`. Reloading applies what's in
  the file but doesn't undo settings you removed; restart tmux for a clean slate.
- Quick experiments without a rebuild: `~/.config/tmux/local.conf` is sourced
  last if it exists.
- To try a config without touching your sessions, run it on a separate server:
  `tmux -L try -f some.conf new`, and `tmux -L try kill-server` when done.
- `~/.config/tmux/bin/tmux-agent demo` starts a fake agent in a background tab
  that goes yellow → red → yellow → green.
