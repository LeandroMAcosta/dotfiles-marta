# AGENTS.md

Guidance for coding agents maintaining this repo.

## What this is

Marta's Mac setup, managed with chezmoi. The chezmoi source is `home/`
(selected by `.chezmoiroot`). On her Mac chezmoi keeps its own clone in
`~/.local/share/chezmoi`, and `dots-update` (defined in `home/dot_zshrc`)
runs `mise upgrade` and then `chezmoi update --force`.

The user is not a programmer. Every change has to work with no manual step
after `dots-update`, and every message a script prints is read by someone
who has never seen a stack trace.

## Rules

- **No Homebrew, anywhere.** Her Mac is an Intel MacBook Pro, and Homebrew's
  installer aborts on Intel ("Homebrew on macOS is only supported on Apple
  Silicon processors!", a hard `uname -m` check with no override).
- **Command-line tools go in `home/dot_config/mise/config.toml`.** Check the
  tool exists in mise's registry first (`registry/<name>.toml` in jdx/mise).
- **Apps go in `APPS` in `home/.chezmoiscripts/run_onchange_before_10-apps.sh`.**
  The script reads the download link and sha256 from Homebrew's public cask
  catalogue (`https://formulae.brew.sh/api/cask/<name>.json`, the `tahoe`
  variation for Intel), installs nothing through brew, and refuses a bundle
  whose binary lacks this Mac's architecture. Before adding a cask, check its
  `depends_on.macos` (her Mac runs macOS 26) and `depends_on.arch`: a cask
  marked `arm` has no Intel build. `herdr-app` is one, which is why only the
  herdr CLI is here.
- **Test the app script without installing** by pointing it at a scratch
  folder: `APPS_DIR=$(mktemp -d) bash home/.chezmoiscripts/run_onchange_before_10-apps.sh`.
  On an Apple silicon Mac, put a stub `uname` that prints `x86_64` first on
  PATH to exercise the Intel downloads.
- **`home/dot_claude/settings.json.tmpl` keeps herdr's SessionStart hook
  exactly as `herdr integration install claude` writes it.** If they differ,
  herdr and chezmoi rewrite the file in turn on every update.
- **`dots-update` uses `--force`,** so chezmoi never stops to ask her about a
  file. Anything she might customise belongs in `~/.zshrc.local`, or in a
  file this repo does not manage.
- **Keep the repo public-safe.** No surnames, employers, hostnames, emails or
  secrets.
- Scripts in `home/.chezmoiscripts/` run in name order. The number prefix is
  that order.

## Checking a change without touching your own home

```bash
tmp=$(mktemp -d)
chezmoi --source home --destination "$tmp/home" \
  --config "$tmp/chezmoi.toml" --persistent-state "$tmp/state.boltdb" \
  --override-data "{\"chezmoi\":{\"homeDir\":\"$tmp/home\"}}" \
  --exclude scripts,externals apply
```

Run the apply twice. Templates that read a deployed file back (settings.json
does) take a different path on the second run, and that path is the one
`dots-update` takes. Without `--override-data`, `.chezmoi.homeDir` still
points at your real home and the templates read your files instead.

Then validate what landed in `$tmp/home` (`jq . .claude/settings.json`,
`zsh -n .zshrc`, `ghostty +validate-config --config-file=...`).
