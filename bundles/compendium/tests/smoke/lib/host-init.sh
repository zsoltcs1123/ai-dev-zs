#!/usr/bin/env bash
#
# Host helpers for fixture-init and smoke. Mirrors bundles/compendium/compendium/references/init.md.

set -euo pipefail

compendium_host_scaffold_dir() {
  local repo_root="$1"
  echo "${repo_root}/bundles/compendium/compendium/references/scaffold"
}

compendium_smoke_fixtures_dir() {
  local script_dir="$1"
  echo "${script_dir}/fixtures/poc"
}

compendium_host_apply_poc_fixture() {
  local workspace="$1"
  local workspace_rel="$2"
  local fixtures_dir="$3"
  cp "$fixtures_dir/scopes.yaml" "$workspace/scopes.yaml"
  sed -i "s/{{WORKSPACE}}/${workspace_rel}/g" "$workspace/scopes.yaml"
  cp -R "$fixtures_dir/loci" "$workspace/"
}

compendium_instance_marker() {
  local repo="$1"
  if [[ -f "$repo/scopes.yaml" ]]; then
    echo "root"
    return 0
  fi
  if [[ -f "$repo/compendium/scopes.yaml" ]]; then
    echo "subdir"
    return 0
  fi
  return 1
}

compendium_refuse_if_instance() {
  local repo="$1"
  if compendium_instance_marker "$repo" >/dev/null 2>&1; then
    echo "compendium init: instance already exists" >&2
    return 1
  fi
  return 0
}

compendium_host_init_root() {
  local repo="$1"
  local repo_root="$2"
  local scaffold
  scaffold="$(compendium_host_scaffold_dir "$repo_root")"

  compendium_refuse_if_instance "$repo" || return 1

  mkdir -p "$repo"
  cp -R "$scaffold/." "$repo/"
  sed -i 's/{{WORKSPACE}}/./g' "$repo/scopes.yaml"
}

compendium_host_init_subdir() {
  local repo="$1"
  local repo_root="$2"
  local scaffold workspace="$repo/compendium"
  scaffold="$(compendium_host_scaffold_dir "$repo_root")"

  compendium_refuse_if_instance "$repo" || return 1

  mkdir -p "$workspace"
  cp -R "$scaffold/." "$workspace/"
  sed -i 's/{{WORKSPACE}}/compendium/g' "$workspace/scopes.yaml"
}

compendium_host_install_bundle() {
  local repo="$1"
  local repo_root="$2"
  (cd "$repo_root" && ./skills/install.sh "$repo" --bundle compendium --skip-external)
}

compendium_host_prek_install() {
  local workspace="$1"
  if ! command -v prek >/dev/null 2>&1; then
    echo "prek not on PATH" >&2
    return 1
  fi
  (cd "$workspace" && prek install -q)
}

# Full host bootstrap (bundle + init + POC fixture + prek). Used by fixture-init.sh only.
compendium_host_fixture_root() {
  local repo="$1"
  local repo_root="$2"
  local fixtures_dir="$3"
  mkdir -p "$repo"
  (cd "$repo" && git init -q)
  compendium_host_install_bundle "$repo" "$repo_root"
  compendium_host_init_root "$repo" "$repo_root"
  compendium_host_apply_poc_fixture "$repo" "." "$fixtures_dir"
  if command -v prek >/dev/null 2>&1; then
    compendium_host_prek_install "$repo"
  fi
}

compendium_host_fixture_subdir() {
  local repo="$1"
  local repo_root="$2"
  local fixtures_dir="$3"
  mkdir -p "$repo"
  (cd "$repo" && git init -q)
  compendium_host_install_bundle "$repo" "$repo_root"
  compendium_host_init_subdir "$repo" "$repo_root"
  compendium_host_apply_poc_fixture "$repo/compendium" "compendium" "$fixtures_dir"
  if command -v prek >/dev/null 2>&1; then
    compendium_host_prek_install "$repo/compendium"
  fi
}