# dotfiles-marta

Marta's Mac setup: Claude Code, an agent manager, a friendlier terminal and a
few apps, installed with one command and kept up to date with another.

Built for a 2020 Intel MacBook Pro on macOS 26. Homebrew's installer refuses
Intel Macs, so nothing here uses it. The apps are downloaded straight from
each vendor and update themselves. [mise](https://mise.jdx.dev) installs the
command-line tools from each project's own prebuilt release.

## Install

Open Terminal (cmd+space, type Terminal) and paste:

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/LeandroMAcosta/dotfiles-marta/main/install.sh)"
```

If the Command Line Tools are missing, a macOS window asks to install them:
click Install. The rest takes a while and needs no input. Any
settings file it replaces is copied to `~/dotfiles-backup-<date>` first.
Running it again is safe.

Then:

1. Quit Terminal and open **Ghostty**.
2. Type `claude` and log in with your Claude account.
3. Open **GitHub Desktop** and sign in.
4. Type `cheatsheet`.

## Update

```
dots-update
```

It upgrades the command-line tools, downloads the latest version of this repo
and installs anything new. The apps and Claude Code update themselves.

## What gets installed

| What | Why |
|---|---|
| Claude desktop app | Claude chat, plus Claude Code in a window |
| [Ghostty](https://ghostty.org) | The terminal. Fast, follows light and dark mode |
| [Claude Code](https://code.claude.com) | Claude in the terminal, installed with Anthropic's own installer |
| [herdr](https://herdr.dev) | Runs several Claude sessions side by side and shows which one needs you |
| GitHub Desktop | Git without git commands |
| TablePlus | Database client, native and light on an Intel Mac |
| Orion | A light browser on Safari's engine that takes Chrome extensions |
| DuckDB | SQL over CSV, Excel and Parquet files |
| Starship, zoxide, fzf, two zsh plugins | A clear prompt, `z` to jump to folders, `ctrl+r` history search, grey suggestions, red typos |
| node, uv | Let Claude start MCP servers through `npx` and `uvx` |
| gh, jq, glow, chezmoi | Support for Claude, the hooks, the cheat sheet and this repo |

Claude Code comes set up for someone new to the terminal (`home/dot_claude/`).
It explains each command before running it, treats every database as
production, and asks before any query that writes. It shows a macOS
notification when it finishes or needs an answer. `sudo`, force pushes and
`git reset --hard` are blocked.

The Herdr desktop app is not included because it runs only on Apple silicon
Macs. The herdr terminal app above does the same job on this one.

To add an app, add a line to `APPS` in
`home/.chezmoiscripts/run_onchange_before_10-apps.sh`. The first part is its
name in Homebrew's catalogue (`https://formulae.brew.sh/cask/<name>`), the
second its name in Applications.

## Your own changes

Files this repo manages are overwritten on every `dots-update`. Put personal
shell aliases and settings in `~/.zshrc.local`, which is never touched.

## If this Mac feels slow

macOS 26's transparent design is hard on the 2020 Intel graphics. System
Settings → Accessibility → Display → **Reduce transparency** and **Reduce
motion** make it noticeably lighter. Use Safari or Orion rather than Chrome,
and quit apps you are not using rather than closing their windows.

## Layout

```
install.sh              first-time bootstrap
home/                   chezmoi source, mirrors ~ (see .chezmoiroot)
  .chezmoiscripts/      apps, tools, Claude Code, herdr hook, in that order
                        (the app list is at the top of the 10-apps script)
  .chezmoiexternal.toml the two zsh plugins, pinned by checksum
  dot_zprofile          PATH for mise and Claude Code
  dot_zshrc             prompt, history, completion, aliases, dots-update
  dot_claude/           Claude Code's instructions, settings and hooks
  dot_config/           Ghostty, herdr, mise, git, starship, the cheat sheet
```
