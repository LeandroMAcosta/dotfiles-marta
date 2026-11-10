#!/bin/bash
# Lets herdr see what each Claude session is doing (working, waiting, done).
# Runs on every apply but only acts when herdr reports its hook missing or
# out of date, which is what happens after herdr upgrades itself.
#
# The hook it installs is already listed in ~/.claude/settings.json (see
# dot_claude/settings.json.tmpl), so the file chezmoi writes and the file
# herdr expects stay the same.
set -euo pipefail
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

command -v herdr >/dev/null && command -v claude >/dev/null || exit 0

# Read the status into a variable first: piping it into `grep -q` lets grep
# exit early, herdr dies of SIGPIPE, and pipefail reads that as "not current".
herdr_status=$(herdr integration status 2>/dev/null || true)
if ! grep -q '^claude: current' <<<"$herdr_status"; then
  echo "==> Connecting herdr to Claude Code"
  herdr integration install claude
fi
