#!/usr/bin/env bash

set -euo pipefail

SMOKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPENDIUM_ROOT="$(cd "$SMOKE_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$COMPENDIUM_ROOT/../.." && pwd)"
HOST_BASE="$COMPENDIUM_ROOT/compendium-host"
ROOT_HOST="$HOST_BASE/root"
SUBDIR_HOST="$HOST_BASE/subdir"
SCRATCH="$HOST_BASE/_scratch"

# shellcheck source=lib/assert.sh
source "$SMOKE_DIR/lib/assert.sh"
# shellcheck source=lib/host-init.sh
source "$SMOKE_DIR/lib/host-init.sh"

require_fixtures() {
  if [[ ! -f "$ROOT_HOST/scopes.yaml" ]] || [[ ! -f "$SUBDIR_HOST/compendium/scopes.yaml" ]]; then
    echo "Missing fixture hosts. Run: ./bundles/compendium/tests/smoke/fixture-init.sh" >&2
    exit 1
  fi
}

rm -rf "$SCRATCH"
mkdir -p "$SCRATCH"
require_fixtures

scenario_bundle_on_fixture() {
  echo "scenario: bundle-on-fixture"
  assert_dir "compendium skill on root host" "$ROOT_HOST/.agents/skills/compendium"
  assert_file "compendium SKILL.md" "$ROOT_HOST/.agents/skills/compendium/SKILL.md"
  assert_dir "summarize on root host" "$ROOT_HOST/.agents/skills/summarize"
  assert_dir "compendium skill on subdir host" "$SUBDIR_HOST/.agents/skills/compendium"
}

scenario_root_fixture_layout() {
  echo "scenario: root-fixture-layout"
  assert_file "scopes.yaml at root" "$ROOT_HOST/scopes.yaml"
  test ! -d "$ROOT_HOST/contracts" && smoke_pass "no host contracts/" || smoke_fail "contracts/ should not exist"
  assert_dir "POC rust wikis dir" "$ROOT_HOST/loci/programming/rust/wikis"
  assert_eq "scopes root field" "." "$(grep '^root:' "$ROOT_HOST/scopes.yaml" | awk '{print $2}')"
  test ! -f "$ROOT_HOST/AGENTS.md" && smoke_pass "no host AGENTS.md" || smoke_fail "host AGENTS.md should not exist"
}

scenario_subdir_fixture_layout() {
  echo "scenario: subdir-fixture-layout"
  assert_file "scopes.yaml under compendium/" "$SUBDIR_HOST/compendium/scopes.yaml"
  assert_eq "scopes root field" "compendium" "$(grep '^root:' "$SUBDIR_HOST/compendium/scopes.yaml" | awk '{print $2}')"
  test ! -f "$SUBDIR_HOST/compendium/AGENTS.md" && smoke_pass "no host AGENTS.md" || smoke_fail "host AGENTS.md should not exist"
}

scenario_refuse_double_init() {
  echo "scenario: refuse-double-init"
  local repo="$SCRATCH/refuse-double"
  mkdir -p "$repo"
  (cd "$repo" && git init -q)
  compendium_host_init_root "$repo" "$REPO_ROOT"
  set +e
  compendium_host_init_root "$repo" "$REPO_ROOT" >/dev/null 2>&1
  local code=$?
  set -e
  assert_exit "second init rejected" 1 "$code"
}

scenario_instance_detection() {
  echo "scenario: instance-detection"
  local repo="$SCRATCH/marker"
  mkdir -p "$repo"
  (cd "$repo" && git init -q)
  set +e
  compendium_instance_marker "$repo" >/dev/null 2>&1
  assert_exit "no marker before init" 1 $?
  set -e
  compendium_host_init_root "$repo" "$REPO_ROOT"
  assert_eq "marker after root init" "root" "$(compendium_instance_marker "$repo")"
}

scenario_prek_on_root_fixture() {
  echo "scenario: prek-on-root-fixture"
  if ! command -v prek >/dev/null 2>&1; then
    echo "  SKIP: prek not on PATH"
    return 0
  fi
  set +e
  (cd "$ROOT_HOST" && prek run --all-files -q)
  local code=$?
  set -e
  assert_exit "prek run --all-files on root fixture" 0 "$code"
}

echo "compendium smoke tests"
echo "fixtures: $ROOT_HOST , $SUBDIR_HOST/compendium"
echo "scratch:  $SCRATCH (ephemeral)"
echo

scenario_bundle_on_fixture
echo
scenario_root_fixture_layout
echo
scenario_subdir_fixture_layout
echo
scenario_refuse_double_init
echo
scenario_instance_detection
echo
scenario_prek_on_root_fixture

smoke_summary