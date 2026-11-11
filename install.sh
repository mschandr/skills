#!/usr/bin/env bash
# Install the user-level Claude Code harness into ~/.claude (macOS and Linux).
#
#   ./install.sh          copy files
#   ./install.sh --link   symlink files, so `git pull` in this repo updates every machine
#
# Every existing file is compared by SHA-256 checksum, never assumed identical:
#   identical      -> nothing to back up (copy mode skips it; link mode swaps it for a link)
#   different      -> the existing file is backed up to ~/.claude/backup-<timestamp>/, then replaced
#   broken symlink -> the dangling link is recorded in the backup, then replaced
set -euo pipefail

mode=copy
case "${1:-}" in
  "") ;;
  --link) mode=link ;;
  *) echo "usage: $0 [--link]" >&2; exit 2 ;;
esac

if command -v sha256sum >/dev/null 2>&1; then
  sum() { sha256sum "$1" | cut -d' ' -f1; }
elif command -v shasum >/dev/null 2>&1; then
  sum() { shasum -a 256 "$1" | cut -d' ' -f1; }
else
  echo "need sha256sum or shasum" >&2; exit 1
fi

src="$(cd "$(dirname "$0")/home" && pwd)"
dest="$HOME/.claude"
backup="$dest/backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$dest"
cd "$src"

backed_up="$(mktemp)"
trap 'rm -f "$backed_up"' EXIT

backup_target() {   # $1 = relative path
  echo "$1" >> "$backed_up"
  mkdir -p "$backup/$(dirname "$1")"
  cp -P "$dest/$1" "$backup/$1"
}

find . -type f | sort | while read -r f; do
  f="${f#./}"
  target="$dest/$f"
  want="$(sum "$f")"
  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ] && [ ! -e "$target" ]; then
    backup_target "$f"; rm -f "$target"; state="broken link replaced"
  elif [ -e "$target" ]; then
    have="$(sum "$target")"   # follows symlinks, so a link is judged by its content
    if [ "$have" = "$want" ]; then
      if [ "$mode" = link ] && [ -L "$target" ] && [ "$(readlink "$target")" = "$src/$f" ]; then
        echo "ok         $f (linked, checksum verified)"; continue
      fi
      if [ "$mode" = copy ] && [ ! -L "$target" ]; then
        echo "ok         $f (identical, checksum verified)"; continue
      fi
      rm -f "$target"; state="identical, replaced"
    else
      backup_target "$f"; rm -f "$target"; state="changed, backed up"
    fi
  else
    state="new"
  fi

  if [ "$mode" = link ]; then ln -s "$src/$f" "$target"; else cp "$f" "$target"; fi
  printf '%-10s %s (%s)\n' "$mode" "$f" "$state"
done

[ -s "$backed_up" ] && echo "Backed up $(wc -l < "$backed_up" | tr -d ' ') file(s) to $backup"
echo "Done ($mode). Start a new Claude Code session to pick up the changes."
