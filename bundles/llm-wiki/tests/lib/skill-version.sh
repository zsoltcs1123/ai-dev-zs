#!/usr/bin/env bash
#
# Read wiki skill metadata.version from the dev repo.

set -euo pipefail

wiki_skill_version_from_file() {
  local skill_md="${1:?}"
  if [[ ! -f "$skill_md" ]]; then
    echo "wiki_skill_version: missing $skill_md" >&2
    return 1
  fi
  local ver
  ver="$(awk -F': *' '/^[[:space:]]*version:/ { gsub(/["'\'']/, "", $2); print $2; exit }' "$skill_md" | tr -d '\r' | xargs)"
  if [[ -z "$ver" ]]; then
    echo "wiki_skill_version: no version in $skill_md" >&2
    return 1
  fi
  echo "$ver"
}

wiki_skill_version() {
  local repo_root="${1%/}"
  wiki_skill_version_from_file "$repo_root/wiki/SKILL.md"
}