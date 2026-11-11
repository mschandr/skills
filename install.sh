#!/usr/bin/env bash
# Install the user-level Claude Code harness into ~/.claude (macOS and Linux).
#
#   ./install.sh          copy files (existing ones are backed up first)
#   ./install.sh --link   symlink files instead, so `git pull` in this repo updates every machine
#
# Backups go to ~/.claude/backup-<timestamp>/.
set -euo pipefail
mode=copy
[ "${1:-}" = "--link" ] && mode=link
src="$(cd "$(dirname "$0")/home" && pwd)"
dest="$HOME/.claude"
backup="$dest/backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$dest"
cd "$src"
find . -type f | sort | while read -r f; do
  f="${f#./}"
  target="$dest/$f"
  mkdir -p "$(dirname "$target")"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$src/$f" ]; then
    echo "linked     $f (already)"; continue
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ "$mode" = copy ] && [ ! -L "$target" ] && cmp -s "$f" "$target"; then
      echo "unchanged  $f"; continue
    fi
    mkdir -p "$backup/$(dirname "$f")"
    cp -P "$target" "$backup/$f"
    rm -f "$target"
    echo "backed up  $f"
  fi
  if [ "$mode" = link ]; then
    ln -s "$src/$f" "$target"; echo "linked     $f"
  else
    cp "$f" "$target"; echo "installed  $f"
  fi
done
[ -d "$backup" ] && echo "Backups are in $backup"
echo "Done ($mode). Start a new Claude Code session to pick up the changes."
