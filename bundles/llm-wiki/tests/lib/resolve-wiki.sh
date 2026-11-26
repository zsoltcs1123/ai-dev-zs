#!/usr/bin/env bash
#
# Executable mirror of skills/wiki/references/resolve-wiki.md.
# Kept in sync with the skill doc; validated by tests/scenarios/init/run.sh.

set -euo pipefail

wiki_is_root() {
  local dir="${1%/}"
  [[ -f "$dir/wiki/index.md" ]] \
    && [[ -d "$dir/raw/sources" ]] \
    && [[ -d "$dir/raw/notes" ]] \
    && [[ -d "$dir/raw/reference" ]]
}

wiki_slug_from_root() {
  local root="${1%/}"
  local yaml="$root/.wiki-root.yaml"

  if [[ -f "$yaml" ]]; then
    local slug
    slug="$(awk -F': *' '/^slug:/ { gsub(/["'\'']/, "", $2); print $2; exit }' "$yaml" | tr -d '\r')"
    if [[ -n "$slug" ]]; then
      echo "$slug"
      return 0
    fi
  fi

  basename "$root"
}

wiki_registry_path_for_slug() {
  local repo_root="${1%/}"
  local slug="$2"
  local registry="$repo_root/wikis/AGENTS.md"

  [[ -f "$registry" ]] || return 1

  local line
  while IFS= read -r line; do
    [[ "$line" == \|* ]] || continue
    [[ "$line" == \|*---* ]] && continue

    local row_slug row_path
    row_slug="$(echo "$line" | awk -F'|' '{ print $2 }' | xargs)"
    row_path="$(echo "$line" | awk -F'|' '{ print $3 }' | xargs)"

    [[ "$row_slug" == "$slug" ]] || continue
    [[ -n "$row_path" ]] || continue

    if [[ "$row_path" == /* ]]; then
      echo "$row_path"
    else
      echo "$repo_root/$row_path"
    fi
    return 0
  done < "$registry"

  return 1
}

wiki_collect_roots() {
  local repo_root="${1%/}"
  local -a roots=()

  if wiki_is_root "$repo_root"; then
    roots+=("$repo_root")
  fi

  if [[ -d "$repo_root/wiki" ]] && wiki_is_root "$repo_root/wiki"; then
    roots+=("$repo_root/wiki")
  fi

  if [[ -d "$repo_root/wikis" ]]; then
    local child
    for child in "$repo_root/wikis"/*/; do
      [[ -d "$child" ]] || continue
      child="${child%/}"
      if wiki_is_root "$child"; then
        roots+=("$child")
      fi
    done
  fi

  if [[ "${#roots[@]}" -eq 0 ]]; then
    return 1
  fi

  printf '%s\n' "${roots[@]}" | awk '!seen[$0]++'
}

wiki_root_for_slug() {
  local repo_root="${1%/}"
  local slug="$2"
  local registry_root

  if registry_root="$(wiki_registry_path_for_slug "$repo_root" "$slug" 2>/dev/null)"; then
    registry_root="${registry_root%/}"
    if wiki_is_root "$registry_root"; then
      echo "$registry_root"
      return 0
    fi
  fi

  local root
  while IFS= read -r root; do
    [[ -n "$root" ]] || continue
    if [[ "$(wiki_slug_from_root "$root")" == "$slug" ]]; then
      echo "$root"
      return 0
    fi
  done < <(wiki_collect_roots "$repo_root" || true)

  return 1
}

wiki_root_from_cwd() {
  local cwd="${1%/}"

  while [[ -n "$cwd" && "$cwd" != "/" ]]; do
    if wiki_is_root "$cwd"; then
      echo "$cwd"
      return 0
    fi
    cwd="$(dirname "$cwd")"
  done

  return 1
}

# Resolve wiki root per resolve-wiki.md priority.
# Prints absolute wiki root on stdout.
# Exit 0 = resolved, 1 = none, 2 = ambiguous.
wiki_resolve() {
  local repo_root="${1%/}"
  local cwd="${2:-$repo_root}"
  local explicit_path="${3:-}"
  local explicit_wiki="${4:-}"
  local named_wiki="${5:-}"

  if [[ -n "$explicit_path" ]]; then
    local path_root
    if [[ "$explicit_path" == /* ]]; then
      path_root="${explicit_path%/}"
    else
      path_root="$repo_root/${explicit_path%/}"
    fi

    if wiki_is_root "$path_root"; then
      echo "$path_root"
      return 0
    fi
    return 1
  fi

  if [[ -n "$explicit_wiki" ]]; then
    local slug_root
    if slug_root="$(wiki_root_for_slug "$repo_root" "$explicit_wiki")"; then
      echo "$slug_root"
      return 0
    fi
    return 1
  fi

  if root="$(wiki_root_from_cwd "$cwd" 2>/dev/null)"; then
    echo "$root"
    return 0
  fi

  if [[ -n "$named_wiki" ]]; then
    local named_root
    if named_root="$(wiki_root_for_slug "$repo_root" "$named_wiki")"; then
      echo "$named_root"
      return 0
    fi
    return 1
  fi

  local -a roots=()
  while IFS= read -r root; do
    [[ -n "$root" ]] || continue
    roots+=("$root")
  done < <(wiki_collect_roots "$repo_root" || true)

  if [[ "${#roots[@]}" -eq 1 ]]; then
    echo "${roots[0]}"
    return 0
  fi

  if [[ "${#roots[@]}" -gt 1 ]]; then
    return 2
  fi

  return 1
}
