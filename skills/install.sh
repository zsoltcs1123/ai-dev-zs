#!/usr/bin/env bash
#
# Install the skills in this repo into a project's (or your global) .agents/skills/.
# Once installed there, harnesses that read .agents/skills/ natively (Cursor 2.4+,
# Codex, Copilot, Gemini, Cline, ...) pick them up with no further setup.
#
# Local skills are copied from skills/. Bundles live in ../bundles/; use --bundle.
# External skills (see external.lock) are fetched from upstream at install time.
# Standalone installs get disable-model-invocation: true unless already set.
# Bundle-owned skills follow patch_disable_model_invocation in bundle.yaml.
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
#   ./install.sh --skill NAME    Install only NAME (--skill may be repeated)
#   ./install.sh --bundle ID     Install bundle ID (e.g. compendium)
#
# Re-run to refresh installed copies and pull latest external skills.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUNDLES_DIR="$REPO_ROOT/bundles"
LOCK_FILE="$SCRIPT_DIR/external.lock"
LOCAL_REPO="${SKILLS_LOCAL_REPO:-zsoltcs1123/ai-dev-zs}"
LOCAL_REPO_URL="https://github.com/${LOCAL_REPO}.git"
BUNDLE_HELPER="$SCRIPT_DIR/install-bundle.py"

target=""
global=false
skip_external=false
project_root=""
selected_skills=()
bundle_id=""

skill_selected() {
  local name="$1"
  if [[ ${#selected_skills[@]} -gt 0 ]]; then
    local s
    for s in "${selected_skills[@]}"; do
      [[ "$s" == "$name" ]] && return 0
    done
    return 1
  fi
  if [[ -n "$bundle_id" ]]; then
    return 1
  fi
  return 0
}

bundle_exclusive_names() {
  python3 "$BUNDLE_HELPER" exclusive "$BUNDLES_DIR"
}

is_bundle_exclusive() {
  local name="$1"
  local n
  while IFS= read -r n; do
    [[ -z "$n" ]] && continue
    [[ "$n" == "$name" ]] && return 0
  done < <(bundle_exclusive_names)
  return 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global)
      global=true
      shift
      ;;
    --skip-external)
      skip_external=true
      shift
      ;;
    --list)
      echo "Standalone skills (skills/):"
      for d in "$SCRIPT_DIR"/*/; do
        [ -f "${d}SKILL.md" ] || continue
        echo "  - $(basename "$d")"
      done
      if [[ -f "$LOCK_FILE" ]]; then
        echo ""
        echo "External skills:"
        while IFS= read -r line || [[ -n "$line" ]]; do
          [[ "$line" =~ ^[[:space:]]*# ]] && continue
          [[ -z "${line//[[:space:]]/}" ]] && continue
          read -r name _ _ _ <<< "$line"
          echo "  - $name"
        done < "$LOCK_FILE"
      fi
      if [[ -d "$BUNDLES_DIR" ]]; then
        echo ""
        python3 "$BUNDLE_HELPER" list "$BUNDLES_DIR"
      fi
      exit 0
      ;;
    --bundle)
      if [[ $# -lt 2 ]]; then
        echo "Missing bundle id after --bundle" >&2
        exit 1
      fi
      bundle_id="$2"
      shift 2
      ;;
    --bundle=*)
      bundle_id="${1#--bundle=}"
      shift
      ;;
    --skill)
      if [[ $# -lt 2 ]]; then
        echo "Missing skill name after --skill" >&2
        exit 1
      fi
      if [[ -n "$bundle_id" ]]; then
        echo "Use either --bundle or --skill, not both" >&2
        exit 1
      fi
      selected_skills+=("$2")
      shift 2
      ;;
    --skill=*)
      if [[ -n "$bundle_id" ]]; then
        echo "Use either --bundle or --skill, not both" >&2
        exit 1
      fi
      selected_skills+=("${1#--skill=}")
      shift
      ;;
    --*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      if [[ -n "$target" ]]; then
        echo "Unexpected extra argument: $1" >&2
        exit 1
      fi
      target="$1"
      shift
      ;;
  esac
done

if [[ ${#selected_skills[@]} -gt 0 ]]; then
  local_name=""
  for local_name in "${selected_skills[@]}"; do
    if is_bundle_exclusive "$local_name"; then
      echo "Skill $local_name is bundle-owned; install with --bundle (see bundles/AGENTS.md)" >&2
      exit 1
    fi
  done
fi

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
  local name="$1"
  local apply_patch="${2:-true}"
  if [[ "$apply_patch" == "true" ]]; then
    ensure_manual_invoke_only "$dest/$name/SKILL.md"
  fi
}

install_local_skill_copy() {
  local src="$1" name="$2" lock_path="$3" apply_patch="${4:-true}"
  rm -rf "$dest/$name"
  cp -R "$src" "$dest/$name"
  patch_installed_skill "$name" "$apply_patch"
  register_skill_lock "$name" "$LOCAL_REPO" "github" "$LOCAL_REPO_URL" "main" "$lock_path"
  echo "  copy: $name -> $dest/$name"
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
installed_skill_names=()

install_bundle() {
  local id="$1"
  local bundle_dir="$BUNDLES_DIR/$id"
  if [[ ! -f "$bundle_dir/bundle.yaml" ]]; then
    echo "Unknown bundle: $id (see --list)" >&2
    exit 1
  fi

  local allow_global patch_disable
  read -r allow_global patch_disable < <(
    python3 "$BUNDLE_HELPER" config "$bundle_dir"
  )

  if $global && [[ "$allow_global" != "true" ]]; then
    echo "Bundle $id cannot be installed with --global" >&2
    exit 1
  fi

  local patch_bundle_owned="false"
  if [[ "$patch_disable" == "true" ]]; then
    patch_bundle_owned="true"
  fi

  local name src kind
  while IFS=$'\t' read -r name src kind; do
    [[ -z "$name" ]] && continue
    case "$kind" in
      bundle)
        install_local_skill_copy "$src" "$name" "bundles/$id/$name/SKILL.md" "$patch_bundle_owned"
        ;;
      shared)
        install_local_skill_copy "$src" "$name" "skills/$name/SKILL.md" "true"
        ;;
      *)
        echo "Invalid bundle member $name ($kind)" >&2
        exit 1
        ;;
    esac
    installed_skill_names+=("$name")
    installed=$((installed + 1))
  done < <(python3 "$BUNDLE_HELPER" members "$bundle_dir" "$SCRIPT_DIR")
}

if [[ -n "$bundle_id" ]]; then
  install_bundle "$bundle_id"
  echo "Installed $installed skill(s) from bundle $bundle_id into $dest"
  exit 0
fi

if ! $skip_external; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line//[[:space:]]/}" ]] && continue

    read -r name repo path ref <<< "$line"
    if [[ -z "$name" || -z "$repo" || -z "$path" || -z "$ref" ]]; then
      echo "Invalid external.lock entry: $line" >&2
      exit 1
    fi

    skill_selected "$name" || continue

    fetch_external_skill "$name" "$repo" "$path" "$ref"
    patch_installed_skill "$name"
    plugin_name=""
    [[ "$repo" == "mattpocock/skills" ]] && plugin_name="mattpocock-skills"
    register_skill_lock "$name" "$repo" "github" "https://github.com/${repo}.git" "$ref" "${path}/SKILL.md" "$plugin_name"
    echo "  fetch: $name (from $repo/$path@$ref) -> $dest/$name"
    installed_skill_names+=("$name")
    installed=$((installed + 1))
  done < "$LOCK_FILE"
elif [[ ${#selected_skills[@]} -gt 0 ]]; then
  :
else
  echo "  skip: external skills (--skip-external)"
fi

for d in "$SCRIPT_DIR"/*/; do
  [ -f "${d}SKILL.md" ] || continue
  name="$(basename "$d")"
  skill_selected "$name" || continue
  install_local_skill_copy "$d" "$name" "skills/${name}/SKILL.md" "true"
  installed_skill_names+=("$name")
  installed=$((installed + 1))
done

if [[ ${#selected_skills[@]} -gt 0 ]]; then
  for want in "${selected_skills[@]}"; do
    found=false
    for got in "${installed_skill_names[@]}"; do
      [[ "$want" == "$got" ]] && found=true
    done
    if ! $found; then
      if $skip_external; then
        while IFS= read -r line || [[ -n "$line" ]]; do
          [[ "$line" =~ ^[[:space:]]*# ]] && continue
          [[ -z "${line//[[:space:]]/}" ]] && continue
          read -r ext_name _ _ _ <<< "$line"
          if [[ "$ext_name" == "$want" ]]; then
            echo "Skill $want is external; omit --skip-external or run without --skill filtering" >&2
            exit 1
          fi
        done < "$LOCK_FILE"
      fi
      if is_bundle_exclusive "$want"; then
        echo "Skill $want is bundle-owned; install with --bundle (see bundles/AGENTS.md)" >&2
        exit 1
      fi
      echo "Unknown skill: $want (see --list)" >&2
      exit 1
    fi
  done
fi

echo "Installed $installed skill(s) into $dest"