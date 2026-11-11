#!/usr/bin/env bash
# Install the Claude Code skills harness.
#
#   ./install.sh                     copy into ~/.claude (all your projects on this machine)
#   ./install.sh --link              symlink into ~/.claude, so `git pull` here updates it everywhere
#   ./install.sh --target <project>  copy into <project>/.claude, to commit with that project
#
# Existing files are compared by SHA-256. Identical files are left alone. Changed files are
# backed up to <dest>/backup-<timestamp>/ before being replaced. Only changes are printed.
# Project installs are copy-only and never include the global CLAUDE.md.
set -euo pipefail

usage() { echo "usage: $0 [--link | --target <project-dir>]" >&2; exit 2; }

mode=copy
dest="$HOME/.claude"
scope=user
while [ $# -gt 0 ]; do
  case "$1" in
    --link) mode=link; shift ;;
    --target)
      [ $# -ge 2 ] || usage
      [ -d "$2" ] || { echo "not a directory: $2" >&2; exit 2; }
      dest="$(cd "$2" && pwd)/.claude"; scope=project; shift 2 ;;
    *) usage ;;
  esac
done
if [ "$scope" = project ] && [ "$mode" = link ]; then
  echo "--link and --target can't be combined: project installs are copies, so they can be committed." >&2
  exit 2
fi

if command -v sha256sum >/dev/null 2>&1; then
  sum() { sha256sum "$1" | cut -d' ' -f1; }
elif command -v shasum >/dev/null 2>&1; then
  sum() { shasum -a 256 "$1" | cut -d' ' -f1; }
else
  echo "need sha256sum or shasum" >&2; exit 1
fi

src="$(cd "$(dirname "$0")/home" && pwd)"
backup="$dest/backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$dest"
cd "$src"

log="$(mktemp)"
trap 'rm -f "$log"' EXIT
note() { echo "$1" >> "$log"; }   # one word per file: new, updated, converted, unchanged, skipped

backup_target() {
  mkdir -p "$backup/$(dirname "$1")"
  cp -P "$dest/$1" "$backup/$1"
}

install_file() {
  if [ "$mode" = link ]; then ln -s "$src/$1" "$dest/$1"; else cp "$1" "$dest/$1"; fi
}

find . -type f | sort | while IFS= read -r f; do
  f="${f#./}"
  target="$dest/$f"

  if [ "$scope" = project ] && [ "$f" = CLAUDE.md ]; then
    note skipped; echo "skipped    CLAUDE.md (global rules are not installed into projects)"; continue
  fi
  mkdir -p "$(dirname "$target")"

  # Nothing there yet.
  if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    install_file "$f"; note new; echo "new        $f"; continue
  fi

  # Dangling symlink (e.g. the repo moved): keep a record of it, then replace.
  if [ -L "$target" ] && [ ! -e "$target" ]; then
    backup_target "$f"; rm -f "$target"; install_file "$f"
    note updated; echo "fixed      $f (broken link replaced, old link backed up)"; continue
  fi

  if [ "$(sum "$target")" = "$(sum "$f")" ]; then
    # Same content. Only the form may need changing: a copy where a link is wanted, or vice versa.
    if [ "$mode" = link ] && [ ! -L "$target" ]; then
      rm -f "$target"; install_file "$f"; note converted; echo "converted  $f (copy -> link)"
    elif [ "$mode" = copy ] && [ -L "$target" ]; then
      rm -f "$target"; install_file "$f"; note converted; echo "converted  $f (link -> copy)"
    else
      note unchanged
    fi
    continue
  fi

  # Different content: back up what's there, then replace it.
  backup_target "$f"; rm -f "$target"; install_file "$f"
  note updated; echo "updated    $f (previous version backed up)"
done

count() { grep -cx "$1" "$log" || true; }
echo
echo "Installed to $dest ($mode): $(count new) new, $(count updated) updated, $(count converted) converted, $(count unchanged) unchanged, $(count skipped) skipped."
[ -d "$backup" ] && [ "$(count updated)" -gt 0 ] && echo "Backups: $backup"
echo "Start a new Claude Code session to pick up the changes."
