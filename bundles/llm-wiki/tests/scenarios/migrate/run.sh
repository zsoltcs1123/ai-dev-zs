#!/usr/bin/env bash

set -euo pipefail

SCENARIO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_DIR="$(cd "$SCENARIO_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$TESTS_DIR/.." && pwd)"

# shellcheck source=../../lib/assert.sh
source "$TESTS_DIR/lib/assert.sh"
# shellcheck source=../../lib/resolve-wiki.sh
source "$TESTS_DIR/lib/resolve-wiki.sh"
# shellcheck source=../../lib/wiki-migrate.sh
source "$TESTS_DIR/lib/wiki-migrate.sh"
# shellcheck source=../../lib/wiki-init.sh
source "$TESTS_DIR/lib/wiki-init.sh"
# shellcheck source=../../lib/skill-version.sh
source "$TESTS_DIR/lib/skill-version.sh"

LEGACY="$TESTS_DIR/fixtures/migrate/legacy-1.0"
PARTIAL="$TESTS_DIR/fixtures/migrate/partial-1.2"
SCAFFOLD_DIR="$REPO_ROOT/wiki/references/scaffold"
MIGRATIONS_DIR="$REPO_ROOT/wiki/references/migrations"
TARGET="$(wiki_skill_version "$REPO_ROOT")"

echo "scenario: migrate"
echo

echo "scaffold read"
assert_eq "legacy scaffold fallback" "1.0" "$(wiki_scaffold_read "$LEGACY")"
assert_eq "partial scaffold" "1.2" "$(wiki_scaffold_read "$PARTIAL")"

echo
echo "playbook chain"
CHAIN="$(wiki_migrate_plan_playbook_names "1.0" "$TARGET" "$MIGRATIONS_DIR")"
assert_eq "chain from 1.0" "1.0-to-1.1.md,1.1-to-1.2.md,1.2-to-1.3.md,1.3-to-1.4.md,1.4-to-1.5.md" "$CHAIN"

for pb in 1.0-to-1.1.md 1.1-to-1.2.md 1.2-to-1.3.md 1.3-to-1.4.md 1.4-to-1.5.md; do
  assert_eq "playbook exists: $pb" "true" "$([[ -f "$MIGRATIONS_DIR/$pb" ]] && echo true || echo false)"
done

echo
echo "tier A partial fixture"
PARTIAL_TMP="$(mktemp -d)"
trap 'rm -rf "$PARTIAL_TMP"' EXIT
cp -R "$PARTIAL/." "$PARTIAL_TMP/"
INDEX_BEFORE="$(sha256sum "$PARTIAL_TMP/wiki/index.md" | awk '{ print $1 }')"
wiki_migrate_additive_sync "$PARTIAL_TMP" "$SCAFFOLD_DIR" false
assert_eq "partial adds OBSIDIAN" "true" "$([[ -f "$PARTIAL_TMP/OBSIDIAN.md" ]] && echo true || echo false)"
assert_eq "partial adds raw/reference README" "true" "$([[ -f "$PARTIAL_TMP/raw/reference/README.md" ]] && echo true || echo false)"
INDEX_AFTER="$(sha256sum "$PARTIAL_TMP/wiki/index.md" | awk '{ print $1 }')"
assert_eq "partial index unchanged" "$INDEX_BEFORE" "$INDEX_AFTER"

echo
echo "tier A deny list"
DENY_TMP="$(mktemp -d)"
wiki_init "$DENY_TMP/wikis/deny" "deny" "$SCAFFOLD_DIR" "$DENY_TMP" "wikis/AGENTS.md" "$REPO_ROOT"
echo "custom index marker" >>"$DENY_TMP/wikis/deny/wiki/index.md"
CUSTOM_HASH="$(sha256sum "$DENY_TMP/wikis/deny/wiki/index.md" | awk '{ print $1 }')"
wiki_migrate_additive_sync "$DENY_TMP/wikis/deny" "$SCAFFOLD_DIR" false
assert_eq "deny list keeps index" "$CUSTOM_HASH" "$(sha256sum "$DENY_TMP/wikis/deny/wiki/index.md" | awk '{ print $1 }')"

echo
echo "hub index policy"
HUB_TMP="$(mktemp -d)"
cp -R "$LEGACY/." "$HUB_TMP/"
wiki_index_apply_hub_policy "$HUB_TMP/wiki/index.md"
assert_eq "hub policy removes Sources heading" "false" "$(grep -q '^## Sources' "$HUB_TMP/wiki/index.md" && echo true || echo false)"
assert_eq "hub policy has Concepts" "true" "$(grep -q '^## Concepts' "$HUB_TMP/wiki/index.md" && echo true || echo false)"
assert_eq "hub policy has Reference Corpora" "true" "$(grep -q '^## Reference Corpora' "$HUB_TMP/wiki/index.md" && echo true || echo false)"

echo
echo "log newest first 1.4 to 1.5"
LOG_TMP="$(mktemp -d)"
cp -R "$TESTS_DIR/fixtures/migrate/log-1.4/." "$LOG_TMP/"
wiki_migrate_mechanical_playbook "$LOG_TMP" "1.4-to-1.5.md" "$SCAFFOLD_DIR"
assert_eq "log convention line" "true" "$(grep -q '^Newest entries first' "$LOG_TMP/wiki/log.md" && echo true || echo false)"
FIRST_DATE="$(grep -m1 '^## \[' "$LOG_TMP/wiki/log.md" | sed -n 's/^## \[\([0-9-]*\)\].*/\1/p' | tr -d '\r')"
LAST_DATE="$(grep '^## \[' "$LOG_TMP/wiki/log.md" | tail -1 | sed -n 's/^## \[\([0-9-]*\)\].*/\1/p' | tr -d '\r')"
assert_eq "log newest date first" "2025-06-01" "$FIRST_DATE"
assert_eq "log oldest date last" "2025-01-01" "$LAST_DATE"

echo
echo "merge quick sources 1.3 to 1.4"
QUICK_TMP="$(mktemp -d)"
cp -R "$TESTS_DIR/fixtures/migrate/quick-1.3/." "$QUICK_TMP/"
wiki_migrate_mechanical_playbook "$QUICK_TMP" "1.3-to-1.4.md" "$SCAFFOLD_DIR"
assert_eq "quick file removed" "false" "$([[ -f "$QUICK_TMP/wiki/sources/acme/quick/example.md" ]] && echo true || echo false)"
assert_eq "quick dir removed" "false" "$([[ -d "$QUICK_TMP/wiki/sources/acme/quick" ]] && echo true || echo false)"
MERGED="$QUICK_TMP/wiki/sources/acme/example.md"
assert_eq "merged has document title" "true" "$(grep -q '^# Example Paper' "$MERGED" && echo true || echo false)"
assert_eq "merged has source line" "true" "$(grep -q '^Source:' "$MERGED" && echo true || echo false)"
assert_eq "merged has author line" "true" "$(grep -q '^Author:' "$MERGED" && echo true || echo false)"
TITLE_LINE="$(grep -n '^# Example Paper' "$MERGED" | head -1 | cut -d: -f1)"
QUICK_LINE="$(grep -n '^## Quick summary' "$MERGED" | head -1 | cut -d: -f1)"
assert_eq "title before quick summary" "true" "$([[ -n "$TITLE_LINE" && -n "$QUICK_LINE" && "$TITLE_LINE" -lt "$QUICK_LINE" ]] && echo true || echo false)"
assert_eq "merged quick heading" "true" "$(grep -q '^## Quick summary' "$MERGED" && echo true || echo false)"
assert_eq "merged summary heading" "true" "$(grep -q '^## Summary' "$MERGED" && echo true || echo false)"
assert_eq "no hr between quick and summary" "false" "$(awk '/^## Quick summary$/{q=1; next} /^## Summary$/{exit} q && /^---$/{found=1; exit} END{if(found) print "true"; else print "false"}' "$MERGED")"
assert_eq "citations section last" "## Citations" "$(grep '^## ' "$MERGED" | tail -1 | tr -d '\r')"
assert_eq "no spurious no citations" "false" "$(grep -q 'No citations found' "$MERGED" && echo true || echo false)"

echo
echo "full mechanical apply"
FULL_TMP="$(mktemp -d)"
cp -R "$LEGACY/." "$FULL_TMP/"
wiki_migrate_mechanical_apply "$FULL_TMP" "$REPO_ROOT" "$MIGRATIONS_DIR" "$SCAFFOLD_DIR"
assert_eq "mechanical apply target scaffold" "$TARGET" "$(wiki_scaffold_read "$FULL_TMP")"
assert_eq "mechanical apply has OBSIDIAN" "true" "$([[ -f "$FULL_TMP/OBSIDIAN.md" ]] && echo true || echo false)"
assert_eq "mechanical apply hub index" "false" "$(grep -q '^## Sources' "$FULL_TMP/wiki/index.md" && echo true || echo false)"

smoke_summary