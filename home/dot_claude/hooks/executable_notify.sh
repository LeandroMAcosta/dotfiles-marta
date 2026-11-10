#!/bin/sh
# Shows a macOS notification when Claude finishes or is waiting for an answer.
# Claude Code sends the event as JSON on stdin; its "message" field, when
# present, says what Claude is waiting for. $1 is the fallback text.
input=$(cat)
message=$(printf '%s' "$input" | jq -r '.message // empty' 2>/dev/null)
folder=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)

# Passed as arguments, never pasted into the script, so a quote in the
# message cannot break or change the AppleScript.
osascript \
  -e 'on run argv' \
  -e 'display notification (item 2 of argv) with title (item 1 of argv) sound name "Glass"' \
  -e 'end run' \
  "Claude Code ${folder:+in ${folder##*/}}" "${message:-$1}" >/dev/null 2>&1
exit 0
