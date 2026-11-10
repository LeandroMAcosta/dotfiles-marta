# dotfiles-marta

Marta's Mac setup: Claude Code, an agent manager, a friendlier terminal and a
few apps, installed with one command and kept up to date with another.

Built for a 2020 Intel MacBook Pro on macOS 26. Homebrew no longer ships
Intel builds of command-line tools, so Homebrew installs only the apps here
and [mise](https://mise.jdx.dev) installs the tools from each project's own
prebuilt release.

## Install

Open Terminal (cmd+space, type Terminal) and paste:

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/LeandroMAcosta/dotfiles-marta/main/install.sh)"
```

It asks for your Mac password once, for Homebrew, and takes a while. Any
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

The Claude desktop app is left out on purpose because it is heavy on this Mac.
claude.ai in Safari does the same for chat. To add it, put `cask "claude"`
in the `Brewfile`.

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
Brewfile                apps, installed by Homebrew
install.sh              first-time bootstrap
home/                   chezmoi source, mirrors ~ (see .chezmoiroot)
  .chezmoiscripts/      apps, tools, Claude Code, herdr hook, in that order
  .chezmoiexternal.toml the two zsh plugins, pinned by checksum
  dot_zprofile          PATH for Homebrew, mise and Claude Code
  dot_zshrc             prompt, history, completion, aliases, dots-update
  dot_claude/           Claude Code's instructions, settings and hooks
  dot_config/           Ghostty, herdr, mise, git, starship, the cheat sheet
```
