# tmux workspaces

One tmux session per project folder (a *workspace*), tabs inside it for nvim,
coding agents and shells, and markers plus notifications that say which
workspace and which tab needs you. Plain tmux 3.8, no plugins.

```
▌1 acme_web ▎2 handbook ▌3 infra ▎4 nix                   dq/pd#123 01:42   <- workspaces
▎1 nvim ▌2 claude ▎3 zsh                                                      <- tabs in "handbook"
```

A thick edge and a coloured name show an agent's state: pink-red, it's waiting
on you; green, it's done (clears when you look at it); a light grey edge, it's
working. Tabs keep their width, so nothing moves when states change. Each
workspace's edge is coloured by folder (`~/dq` orange, `~/pb` purple, `~/ag`
cyan) unless an agent there is busy or needs you. Top right: what timewarrior
is tracking, as in the prompt (`tmux-agent timew`). The keys are listed at the
top of `tmux.conf`.

To start, `cd` into a project and run `tmux`: it opens that folder's
workspace, or goes back to it if it's already open. Inside tmux, `C-b W` opens
any other project.

Adapted in October 2026 from a kit drafted in a claude.ai conversation; the
notes at the end record the decisions and what bit us along the way.

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
- For a hands-on trial, copy `tmux.conf` with its `~/.config/tmux/` paths
  pointed at your copies, start it with `tmux -L try -f copy.conf new` from
  your own terminal, and give a single Claude session the hooks with
  `claude --settings hooks.json`.
- `~/.config/tmux/bin/tmux-agent demo` starts a fake agent in a background tab
  that goes working → waiting → working → done.

## Notes

Why it looks and works this way, and what bit us while building it.

- **Keys.** Option as Alt, because tmux understands Alt directly in any
  terminal. Command would need an Alacritty binding per key and collides with
  Alacritty's Cmd+1…9 tabs and the Cmd+Shift+3/4/5 screenshots; Control has
  no terminal code for Ctrl+digit and its letters belong to the shell, Claude
  Code and nvim; Fn never reaches a terminal. On the Italian – Pro layout
  Shift+digit types `! " £ $ % & / ( ) =`, which is what the Alt+Shift+digit
  bindings match. Left out of the original kit: split keys, an nvim split,
  Alt+h/j/k/l pane moves (and the nvim navigator plugin), a sidebar, a reload
  key, a lazygit popup.
- **Look.** Backgrounds get lighter towards the content; agent state is a
  thick edge plus the name's colour, at a fixed width so tabs never shift
  (markers after the name made them move). Explicit hex colours, because
  Alacritty's green and yellow look like the orange folder colour; `~/ag` is
  cyan so red only means "waiting". Tried and dropped: bars at the bottom, a
  single line, pills, no edges, folder colour on names and numbers.
- **Alacritty doesn't implement xterm's modifyOtherKeys,** which tmux's
  `extended-keys` asks for, so a plain Shift+Enter reaches tmux as Enter: the
  fix is Alacritty's Shift+Enter binding, not tmux.
- **Alacritty sends Alt+`£` without the Esc** that marks Alt, so tmux sees a
  plain `£`; hence the Alt+Shift+3 binding. `option_as_alt = "Both"` would
  make `@ # [ ] { }` untypeable on this layout; `"OnlyLeft"` keeps right
  Option for them.
- **The hook script stays silent and cheap.** UserPromptSubmit output would
  reach the model; PostToolUse fires on every tool call, so it exits early when
  nothing changed; and it ignores processes that don't descend from the pane,
  such as background agents with a stale `$TMUX_PANE`.
- **Don't start your tmux server from a Claude Code session's shell:** every
  tab would inherit that session's environment (`CLAUDECODE` and the like).
