#!/usr/bin/env bash
# Build browsable Compendium fake hosts under compendium-host/ (gitignored).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPENDIUM_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$COMPENDIUM_ROOT/../.." && pwd)"
HOST_BASE="$COMPENDIUM_ROOT/compendium-host"
FIXTURES="$(cd "$SCRIPT_DIR/fixtures/poc" && pwd)"

# shellcheck source=lib/host-init.sh
source "$SCRIPT_DIR/lib/host-init.sh"

rm -rf "$HOST_BASE"
mkdir -p "$HOST_BASE"

compendium_host_fixture_root "$HOST_BASE/root" "$REPO_ROOT" "$FIXTURES"
compendium_host_fixture_subdir "$HOST_BASE/subdir" "$REPO_ROOT" "$FIXTURES"

echo "Fixture hosts ready:"
echo "  $HOST_BASE/root"
echo "  $HOST_BASE/subdir"