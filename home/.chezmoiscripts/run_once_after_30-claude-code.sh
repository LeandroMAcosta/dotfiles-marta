#!/bin/bash
# Installs Claude Code with Anthropic's own installer, which keeps it updated
# by itself. Runs once per machine.
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"

if command -v claude >/dev/null; then
  exit 0
fi

echo "==> Installing Claude Code"
curl -fsSL https://claude.ai/install.sh | bash
