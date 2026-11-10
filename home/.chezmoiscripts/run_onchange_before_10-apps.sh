#!/bin/bash
# Installs the Mac apps. Homebrew refuses to install on Intel Macs, so each
# app is downloaded straight from its vendor. The link and its checksum come
# from Homebrew's public app catalogue, which still lists the Intel builds.
# Apps already in Applications are left alone: they update themselves.
# chezmoi re-runs this whenever this file changes.
set -uo pipefail

# Catalogue name, then the app's name in Applications.
APPS=(
  "claude|Claude.app"
  "ghostty|Ghostty.app"
  "github|GitHub Desktop.app"
  "tableplus|TablePlus.app"
  "orion|Orion.app"
)
# The catalogue files a build under the macOS codename, prefixed with arm64_
# for Apple silicon. tahoe is macOS 26, the last version for Intel Macs.
MACOS_VARIATION=tahoe
[[ $(uname -m) == arm64 ]] && MACOS_VARIATION=arm64_tahoe
APPS_DIR=${APPS_DIR:-/Applications}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# Downloads the app, checks it, and copies the bundle to $work/stage.
# Prints the staged bundle's path.
fetch_app() {
  local cask=$1 app=$2 info url sha file found mount
  info=$(curl -fsSL "https://formulae.brew.sh/api/cask/$cask.json") || return 1
  url=$(jq -r --arg v "$MACOS_VARIATION" '.variations[$v].url // .url' <<<"$info")
  sha=$(jq -r --arg v "$MACOS_VARIATION" '.variations[$v].sha256 // .sha256' <<<"$info")
  file="$work/$cask.${url##*.}"

  curl -fL --progress-bar -o "$file" "$url" >&2 || return 1
  if [[ $sha != no_check ]] && ! shasum -a 256 -c --status <<<"$sha  $file"; then
    echo "  The download does not match its checksum." >&2
    return 1
  fi

  mkdir -p "$work/stage"
  case $file in
    *.dmg)
      # Copy the app out and unmount right away: hdiutil detach takes one
      # volume at a time, and a volume left mounted outlives this script.
      mount="$work/mnt-$cask"
      hdiutil attach -nobrowse -readonly -quiet -mountpoint "$mount" "$file" </dev/null >&2 ||
        return 1
      [[ -d "$mount/$app" ]] && ditto "$mount/$app" "$work/stage/$app"
      hdiutil detach -quiet "$mount" >&2 ;;
    *.zip)
      ditto -x -k "$file" "$work/$cask" >&2 || return 1
      found=$(find "$work/$cask" -maxdepth 2 -name "$app" -type d | head -1)
      [[ -n $found ]] && mv "$found" "$work/stage/$app" ;;
    *)
      echo "  Unknown download type: $url" >&2
      return 1 ;;
  esac
  found="$work/stage/$app"
  [[ -d $found ]] || { echo "  $app is not in the download." >&2; return 1; }

  local exe
  exe=$(defaults read "$found/Contents/Info" CFBundleExecutable)
  if ! lipo -archs "$found/Contents/MacOS/$exe" | grep -qw "$(uname -m)"; then
    echo "  This download does not run on this Mac's processor." >&2
    return 1
  fi
  printf '%s\n' "$found"
}

failed=()
for entry in "${APPS[@]}"; do
  cask=${entry%%|*} app=${entry#*|}
  if [[ -d "$APPS_DIR/$app" ]]; then
    continue
  fi
  echo "==> Installing ${app%.app}"
  if bundle=$(fetch_app "$cask" "$app") && ditto "$bundle" "$APPS_DIR/$app"; then
    echo "  Done."
  else
    failed+=("${app%.app}")
  fi
done

if (( ${#failed[@]} )); then
  echo "These apps did not install: ${failed[*]}. Run dots-update to try again."
fi
exit 0
