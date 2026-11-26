#!/usr/bin/env bash

set -euo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

failed=0

for scenario in init migrate; do
  echo "== scenario: $scenario =="
  if ! "$TESTS_DIR/scenarios/$scenario/run.sh"; then
    failed=$((failed + 1))
  fi
  echo
done

if [[ "$failed" -gt 0 ]]; then
  echo "tests: $failed scenario(s) failed" >&2
  exit 1
fi

echo "tests: all scenarios passed"