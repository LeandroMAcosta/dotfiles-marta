#!/bin/sh
# The line under Claude's input box: model, folder and git branch.
input=$(cat)
model=$(printf '%s' "$input" | jq -r '.model.display_name // "Claude"')
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
branch=$(git -C "${dir:-.}" branch --show-current 2>/dev/null)

printf '%s · %s' "$model" "${dir##*/}"
[ -n "$branch" ] && printf ' · %s' "$branch"
exit 0
