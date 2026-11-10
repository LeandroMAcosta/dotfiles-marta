#!/bin/bash
# One-time setup for a new Mac. Paste this into Terminal:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/LeandroMAcosta/dotfiles-marta/main/install.sh)"
#
# Bootstrap only: Apple's Command Line Tools, mise and chezmoi. Everything else
# (apps, tools, settings, Claude Code) is chezmoi's job, so it also happens on
# dots-update. No Homebrew: its installer refuses Intel Macs.
set -euo pipefail

REPO="https://github.com/LeandroMAcosta/dotfiles-marta.git"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

say() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }

if [[ $(uname -s) != Darwin ]]; then
  echo "This setup is for macOS only."
  exit 1
fi

# git comes with Apple's Command Line Tools, and chezmoi needs git to
# download the settings.
if ! xcode-select -p >/dev/null 2>&1; then
  say "Apple's Command Line Tools (a window opens: click Install)"
  xcode-select --install || true
  echo "Waiting for it to finish. If you closed the window, run this script again."
  for _ in $(seq 180); do
    xcode-select -p >/dev/null 2>&1 && break
    sleep 10
  done
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "The Command Line Tools did not install. Run this script again."
    exit 1
  fi
fi

say "mise, which installs the command-line tools"
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
command -v mise >/dev/null || curl -fsSL https://mise.run | sh

say "Downloading the settings"
chezmoi=(mise exec chezmoi@latest -- chezmoi)
if [[ -d "$HOME/.local/share/chezmoi/.git" ]]; then
  "${chezmoi[@]}" git pull -- --ff-only
else
  "${chezmoi[@]}" init "$REPO"
fi

# chezmoi replaces these files; keep a copy of any that already exist.
while IFS= read -r target; do
  if [[ -f $target && ! -L $target ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "${target#"$HOME"/}")"
    cp -p "$target" "$BACKUP_DIR/${target#"$HOME"/}"
  fi
done < <("${chezmoi[@]}" managed --include=files --path-style=absolute)
[[ -d $BACKUP_DIR ]] && echo "Your previous settings are saved in $BACKUP_DIR"

say "Installing apps, tools and settings (this takes a while)"
"${chezmoi[@]}" apply --force

cat <<'EOF'

All done. Next:
  1. Quit Terminal and open Ghostty (Applications, or cmd+space and type Ghostty).
  2. Type `claude` and log in with your Claude account.
  3. Open GitHub Desktop and sign in to GitHub.
  4. Type `cheatsheet` to see the basics.
EOF
