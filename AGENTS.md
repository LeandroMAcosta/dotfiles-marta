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

- **Command-line tools go in `home/dot_config/mise/config.toml`, never the
  Brewfile.** Her Mac is an Intel MacBook Pro and Homebrew ships no Intel
  bottles any more, so a formula compiles from source. Check a tool exists in
  mise's registry first (`registry/<name>.toml` in jdx/mise).
- **Apps go in the `Brewfile`** as casks. Check `depends_on.macos` in
  `https://formulae.brew.sh/api/cask/<name>.json`; her Mac runs macOS 26.
  Check `depends_on.arch` too: a cask marked `arm` will not install on Intel.
  `herdr-app` is one, which is why only the herdr CLI is here.
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
