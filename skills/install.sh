#!/usr/bin/env bash
#
# Install the skills in this repo into a project's (or your global) .agents/skills/.
# Once installed there, harnesses that read .agents/skills/ natively (Cursor 2.4+,
# Codex, Copilot, Gemini, Cline, ...) pick them up with no further setup.
#
# Local skills are copied from this repo. External skills (see external.lock) are
# fetched from upstream at install time. All installed skills get
# disable-model-invocation: true so only explicit /skill invocation runs them.
# Installs also register sources in the npx skills lock file (~/.agents/.skill-lock.json
# for --global, skills-lock.json for project installs) so `npx skills list` shows
# the correct upstream repo instead of "local".
#
# Prefer this script for the full curated set (local + external). For local skills
# only, npx skills also works when Node is available:
#   npx skills add zsoltcs1123/ai-dev-zs -a cursor -y
#
# Usage:
#   ./install.sh [TARGET]        Install into TARGET/.agents/skills/ (default: current dir)
#   ./install.sh --global        Install into ~/.agents/skills/
#   ./install.sh --list          List installable skills and exit
#   ./install.sh --skip-external Install local skills only (skip upstream fetches)
#
# Re-run to refresh installed copies and pull latest external skills.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCK_FILE="$SCRIPT_DIR/external.lock"
LOCAL_REPO="${SKILLS_LOCAL_REPO:-zsoltcs1123/ai-dev-zs}"
LOCAL_REPO_URL="https://github.com/${LOCAL_REPO}.git"

target=""
global=false
skip_external=false
project_root=""

for arg in "$@"; do
  case "$arg" in
    --global) global=true ;;
    --skip-external) skip_external=true ;;
    --list)
      echo "Installable skills:"
      while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line//[[:space:]]/}" ]] && continue
        read -r name _ _ _ <<< "$line"
        echo "  - $name (external)"
      done < "$LOCK_FILE"
      for d in "$SCRIPT_DIR"/*/; do
        [ -f "${d}SKILL.md" ] || continue
        echo "  - $(basename "$d")"
      done
      exit 0
      ;;
    --*) echo "Unknown option: $arg" >&2; exit 1 ;;
    *) target="$arg" ;;
  esac
done

if $global; then
  dest="$HOME/.agents/skills"
  project_root=""
else
  project_root="${target:-$PWD}"
  dest="$project_root/.agents/skills"
fi

mkdir -p "$dest"

register_skill_lock() {
  local name="$1" source="$2" source_type="$3" source_url="$4" ref="$5" skill_path="$6" plugin_name="${7:-}"

  if ! command -v python3 >/dev/null 2>&1; then
    echo "  warn: python3 missing; $name not registered in skills lock (npx skills list may show Source: local)" >&2
    return 0
  fi

  if $global; then
    python3 - "$name" "$source" "$source_type" "$source_url" "$ref" "$skill_path" "$plugin_name" <<'PY'
import json
import os
import sys
from datetime import datetime, timezone

name, source, source_type, source_url, ref, skill_path, plugin_name = sys.argv[1:8]
lock_path = os.path.join(os.path.expanduser("~"), ".agents", ".skill-lock.json")

try:
    with open(lock_path, encoding="utf-8") as handle:
        lock = json.load(handle)
except (FileNotFoundError, json.JSONDecodeError):
    lock = {"version": 3, "skills": {}, "dismissed": {}}

if lock.get("version", 0) < 3:
    lock = {"version": 3, "skills": {}, "dismissed": lock.get("dismissed", {})}

now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3] + "Z"
existing = lock["skills"].get(name, {})
entry = {
    "source": source,
    "sourceType": source_type,
    "sourceUrl": source_url,
    "ref": ref,
    "skillPath": skill_path,
    "installedAt": existing.get("installedAt", now),
    "updatedAt": now,
}
if plugin_name:
    entry["pluginName"] = plugin_name
if existing.get("skillFolderHash"):
    entry["skillFolderHash"] = existing["skillFolderHash"]

lock["skills"][name] = entry
os.makedirs(os.path.dirname(lock_path), exist_ok=True)
with open(lock_path, "w", encoding="utf-8") as handle:
    json.dump(lock, handle, indent=2)
    handle.write("\n")
PY
  else
    python3 - "$project_root" "$name" "$source" "$source_type" "$source_url" "$ref" "$skill_path" <<'PY'
import json
import os
import sys

project_root, name, source, source_type, source_url, ref, skill_path = sys.argv[1:8]
lock_path = os.path.join(project_root, "skills-lock.json")

try:
    with open(lock_path, encoding="utf-8") as handle:
        lock = json.load(handle)
except (FileNotFoundError, json.JSONDecodeError):
    lock = {"version": 1, "skills": {}}

if lock.get("version", 0) < 1:
    lock = {"version": 1, "skills": {}}

existing = lock["skills"].get(name, {})
entry = {
    "source": source,
    "sourceType": source_type,
    "sourceUrl": source_url,
    "ref": ref,
    "skillPath": skill_path,
}
if existing.get("computedHash"):
    entry["computedHash"] = existing["computedHash"]

lock["skills"][name] = entry
with open(lock_path, "w", encoding="utf-8") as handle:
    json.dump(lock, handle, indent=2)
    handle.write("\n")
PY
  fi
}

ensure_manual_invoke_only() {
  local skill_md="$1"

  if grep -qE '^disable-model-invocation:[[:space:]]*true[[:space:]]*$' "$skill_md"; then
    return 0
  fi

  awk '
    BEGIN { fm=0; inserted=0 }
    /^---$/ {
      fm++
      if (fm == 2 && !inserted) {
        print "disable-model-invocation: true"
        inserted=1
      }
      print
      next
    }
    /^disable-model-invocation:/ { next }
    /^[[:space:]]+disable-model-invocation:/ { next }
    { print }
  ' "$skill_md" > "${skill_md}.tmp"
  mv "${skill_md}.tmp" "$skill_md"
}

patch_installed_skill() {
  ensure_manual_invoke_only "$dest/$1/SKILL.md"
}

fetch_external_skill() {
  local name="$1" repo="$2" path="$3" ref="$4"
  local tmp clone_dir

  if ! command -v git >/dev/null 2>&1; then
    echo "git required to fetch external skill: $name" >&2
    exit 1
  fi

  tmp="$(mktemp -d)"
  clone_dir="$tmp/repo"

  if git clone --depth 1 --branch "$ref" --filter=blob:none --sparse \
    "https://github.com/${repo}.git" "$clone_dir" 2>/dev/null; then
    :
  else
    git clone --filter=blob:none --sparse "https://github.com/${repo}.git" "$clone_dir"
    (cd "$clone_dir" && git checkout "$ref")
  fi

  (cd "$clone_dir" && git sparse-checkout set "$path")

  rm -rf "$dest/$name"
  cp -R "$clone_dir/$path" "$dest/$name"
  rm -rf "$tmp"
}

installed=0

if ! $skip_external; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line//[[:space:]]/}" ]] && continue

    read -r name repo path ref <<< "$line"
    if [[ -z "$name" || -z "$repo" || -z "$path" || -z "$ref" ]]; then
      echo "Invalid external.lock entry: $line" >&2
      exit 1
    fi

    fetch_external_skill "$name" "$repo" "$path" "$ref"
    patch_installed_skill "$name"
    plugin_name=""
    [[ "$repo" == "mattpocock/skills" ]] && plugin_name="mattpocock-skills"
    register_skill_lock "$name" "$repo" "github" "https://github.com/${repo}.git" "$ref" "${path}/SKILL.md" "$plugin_name"
    echo "  fetch: $name (from $repo/$path@$ref) -> $dest/$name"
    installed=$((installed + 1))
  done < "$LOCK_FILE"
else
  echo "  skip: external skills (--skip-external)"
fi

for d in "$SCRIPT_DIR"/*/; do
  [ -f "${d}SKILL.md" ] || continue
  name="$(basename "$d")"
  rm -rf "$dest/$name"
  cp -R "$d" "$dest/$name"
  patch_installed_skill "$name"
  register_skill_lock "$name" "$LOCAL_REPO" "github" "$LOCAL_REPO_URL" "main" "skills/${name}/SKILL.md"
  echo "  copy: $name -> $dest/$name"
  installed=$((installed + 1))
done

echo "Installed $installed skill(s) into $dest"
