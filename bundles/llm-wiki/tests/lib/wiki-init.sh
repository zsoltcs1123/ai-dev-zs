#!/usr/bin/env bash
#
# Minimal init helper for tests. Mirrors skills/wiki/references/commands/init.md.

set -euo pipefail

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=resolve-wiki.sh
source "$LIB_DIR/resolve-wiki.sh"
# shellcheck source=skill-version.sh
source "$LIB_DIR/skill-version.sh"

wiki_init() {
  local target="${1%/}"
  local slug="$2"
  local scaffold_dir="${3%/}"
  local repo_root="${4%/}"
  local registry_rel="${5:-wikis/AGENTS.md}"
  local skill_repo_root="${6:-$repo_root}"

  if wiki_is_root "$target"; then
    echo "wiki init: target already looks like a wiki root: $target" >&2
    return 1
  fi

  local scaffold_ver
  scaffold_ver="$(wiki_skill_version "${skill_repo_root%/}")"

  mkdir -p "$target"
  cp -R "$scaffold_dir/." "$target/"

  cat >"$target/.wiki-root.yaml" <<EOF
slug: $slug
name: $slug
scaffold: "$scaffold_ver"
EOF

  local host_registry="$repo_root/$registry_rel"
  mkdir -p "$(dirname "$host_registry")"

  if [[ ! -f "$host_registry" ]]; then
    cat >"$host_registry" <<'EOF'
# Wikis

| Slug | Path | Notes |
| --- | --- | --- |
EOF
  fi

  local rel_path="${target#"$repo_root"/}"
  printf '| %s | %s/ | Test wiki |\n' "$slug" "$rel_path" >>"$host_registry"
}