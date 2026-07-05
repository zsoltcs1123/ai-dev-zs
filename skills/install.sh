#!/usr/bin/env bash
#
# Install the skills in this repo into a project's (or your global) .agents/skills/.
# Once installed there, harnesses that read .agents/skills/ natively (Cursor 2.4+,
# Codex, Copilot, Gemini, Cline, ...) pick them up with no further setup.
#
# Usage:
#   ./install.sh [TARGET]        Install into TARGET/.agents/skills/ (default: current dir)
#   ./install.sh --global        Install into ~/.agents/skills/
#   ./install.sh --list          List installable skills and exit
#
# Skills are copied as snapshots; re-run this script to update them.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

target=""
global=false

for arg in "$@"; do
  case "$arg" in
    --global) global=true ;;
    --list)
      echo "Installable skills:"
      for d in "$SCRIPT_DIR"/*/; do
        [ -f "${d}SKILL.md" ] && echo "  - $(basename "$d")"
      done
      exit 0
      ;;
    --*) echo "Unknown option: $arg" >&2; exit 1 ;;
    *) target="$arg" ;;
  esac
done

if $global; then
  dest="$HOME/.agents/skills"
else
  dest="${target:-$PWD}/.agents/skills"
fi

mkdir -p "$dest"

installed=0
for d in "$SCRIPT_DIR"/*/; do
  [ -f "${d}SKILL.md" ] || continue
  name="$(basename "$d")"
  link="$dest/$name"
  rm -rf "$link"
  cp -R "$d" "$link"
  echo "  copy: $name -> $link"
  installed=$((installed + 1))
done

echo "Installed $installed skill(s) into $dest"
