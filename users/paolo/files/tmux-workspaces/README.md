# tmux workspaces

One tmux session per project folder (a *workspace*), tabs inside it for nvim,
coding agents and shells, and markers plus notifications that say which
workspace and which tab needs you. Plain tmux 3.8, no plugins.

```
▌1 acme_web ▎2 handbook ▌3 infra ▎4 nix                                     <- workspaces
▎1 nvim ▌2 claude ▎3 zsh                                   dq/pd#123 01:42   <- tabs in "handbook"
```

A thick edge and a coloured name show an agent's state: pink-red, it's waiting
on you; green, it's done (clears when you look at it); a light grey edge, it's
working. Tabs keep their width, so nothing moves when states change. Each
workspace's edge is coloured by folder (`~/dq` orange, `~/pb` purple, `~/ag`
cyan) unless an agent there is busy or needs you. When the workspaces don't
fit, every name is cut to the same length, the longest that fits (short names
stay whole), so you still see each agent's state. Right of the tabs: what
timewarrior is tracking, as in the prompt plus the annotation (`tmux-agent
timew`). The keys are listed at the top of `tmux.conf`.

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
| Claude Code hooks | `claude-hooks.json` here, merged on activation by `users/paolo/tmux-workspaces.nix` | merged into `~/.dq/.claude/settings.json` and `~/.ag/.claude/settings.json` |

Only ebisu imports the module (`flake.nix`); kitsune and inari keep the plain
tmux setup from `interactive.nix`.

How a marker gets there: Claude Code runs a hook → `tmux-agent state
working|waiting|done|clear` sets the pane option `@agent` → both status rows
and the `C-b w` tree show it. On *waiting* and *done* the helper also rings the
bell unless you're looking at the pane, shows a message on other tmux clients,
and sends a macOS notification when no tmux client has focus. The bell is
`afplay` of the sound Alacritty's bell plays (Tink), so it's heard from any
workspace: a bell in the pane only reaches clients showing its workspace, and
with `bell-action other` not even them when it's the tab on screen. The helper
is macOS-only (`afplay`, `osascript`), like the module, which only ebisu imports. A *done* in
the pane you're looking at (shown by a client with focus) is skipped; with the
terminal behind another app it isn't, and coming back clears it.

Which hooks set what (`claude-hooks.json`, from Claude Code's hooks reference):

- *working*: UserPromptSubmit, and after every tool call whether it worked or
  failed (PostToolUse, PostToolUseFailure).
- *waiting*: PermissionRequest, which fires as the prompt appears (the
  permission Notification only comes after about 6 s without typing, and each
  keystroke restarts the wait), and Notification for questions.
- *done*: Stop, or StopFailure when an API error ends the turn. A turn that
  ends with background agents still running stays *working* (the Stop event
  lists them in `background_tasks`): Claude picks the work up when they finish.
- *clear*: SessionStart (not after compaction, which fires it too) and
  SessionEnd.

Claude Code runs no hook when you interrupt it with Esc, but it also reports its
own status to the terminal (OSC 7501), which tmux's development branch
(next-3.9, pinned in `tmux-workspaces.nix` until 3.9 is out) keeps as
`#{pane_program_state}`. The markers trust that over the hooks: *working* and
*blocked* (waiting) show as they are, *idle* shows nothing, so Esc leaves no
stale marker, and *done* or *error* show until you visit. Agents that don't
report it keep the hooks' state; Alt+a reads the same state as the bars. The
hooks still ring the bell, post the notifications and order Alt+a.

The desktop notification goes through `terminal-notifier`: its title is the
workspace and tab, a waiting agent's says what it needs (the tool it wants, or
its question), a failed turn's says why, and clicking it brings Alacritty to the
front on that tab. Each pane has at most one out, replaced by the next, and
taken back when you visit the pane or the agent gets back to work (`tmux-agent
seen`, from the `pane-focus-in` hook). Without terminal-notifier the helper
falls back to `osascript`, whose notifications count as Script Editor's: a
click opens Script Editor.

terminal-notifier is `pkgs/terminal-notifier` (its 3.x release; nixpkgs has an
x86_64-only 2.0.0), and the helper runs a copy of it,
`~/Applications/tmux-agent.app`, that `tmux-workspaces.nix` makes on
activation. Two reasons for a copy:

- A notification's icon is always its sender's, so Claude's icon needs an app
  of its own: the copy has its own bundle id, the name tmux-agent (not Claude
  or Claude Code, which would pass it off as Anthropic's), and the icon of the
  installed Claude app (not kept in this public repo), and is re-signed ad hoc.
  Without the Claude app it keeps terminal-notifier's icon.
- macOS lets an app post notifications only from an Applications folder: from
  the nix store or Homebrew's Cellar it gets no permission prompt and fails, and
  home-manager only links apps.

The copy is rebuilt when the package or Claude's icon changes. Its first
notification asks for permission (System Settings → Notifications →
tmux-agent).

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

Claude Code writes its own settings files (`/config`, permission answers), so
the hooks can't be read-only links into the nix store. Instead, home-manager's
activation (`tmuxAgentClaudeHooks` in `users/paolo/tmux-workspaces.nix`) merges
`claude-hooks.json` into both profiles' `settings.json`: it replaces the
entries that call `tmux-agent`, keeps everything else, and rewrites the file
only when that changes something. A profile without a `settings.json` yet is
skipped, and plain `claude` (`~/.claude`) doesn't get them. So after changing
`claude-hooks.json`, `snix`; a hook Claude Code dropped from its settings comes
back the same way.

Claude Code reads hooks when a session starts, so sessions already running
don't report their state, or keep the old hooks.

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
  bindings match. `C-b b` goes back from Alt+a's jumps because tmux's own
  `C-b L` and `C-b l` each cover only one case (the agent in another
  workspace, or in the same one); it returns to where you were before the
  first of several jumps, not to the agent you just answered, and a second
  press goes back to the agent. Left out of the original kit: split keys, an
  nvim split, Alt+h/j/k/l pane moves (and the nvim navigator plugin), a
  sidebar, a reload key, a lazygit popup.
- **Look.** Backgrounds get lighter towards the content; agent state is a
  thick edge plus the name's colour, at a fixed width so tabs never shift
  (markers after the name made them move). Explicit hex colours, because
  Alacritty's green and yellow look like the orange folder colour; `~/ag` is
  cyan so red only means "waiting". Tried and dropped: bars at the bottom, a
  single line, pills, no edges, folder colour on names and numbers.
- **Too many workspaces for the width.** A status line that isn't a tmux list
  loses its right end first: with 8 or more long names, the last workspaces
  (and their agents' states) and the timewarrior snippet, then top right,
  disappeared. Both rows are lists now, so tmux keeps the current item and the
  right side and scrolls the rest; the snippet moved to the tabs row, which has
  fewer items; and names get shorter so every workspace fits. `tmux-agent fit`
  works out one length for all names, on tmux hooks (workspaces opened, closed
  or renamed; clients attached, detached or resized); it doesn't depend on the
  current workspace, so switching moves nothing. Working it out in tmux formats
  instead made each redraw 5 to 30 times slower. Tried and dropped: hiding
  names farthest from the current workspace first (which names showed changed
  on every switch, which was confusing), dropping vowels, dropping the client
  prefix (`donq_`); also considered: wrapping onto a third row.
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
