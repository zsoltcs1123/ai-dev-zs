#!/usr/bin/env bash

set -euo pipefail

SMOKE_PASS=0
SMOKE_FAIL=0

smoke_pass() {
  SMOKE_PASS=$((SMOKE_PASS + 1))
  echo "  PASS: $1"
}

smoke_fail() {
  SMOKE_FAIL=$((SMOKE_FAIL + 1))
  echo "  FAIL: $1" >&2
}

assert_eq() {
  local label="$1"
  local expected="$2"
  local actual="$3"

  if [[ "$expected" == "$actual" ]]; then
    smoke_pass "$label"
  else
    smoke_fail "$label (expected '$expected', got '$actual')"
  fi
}

assert_exit() {
  local label="$1"
  local expected_exit="$2"
  local actual_exit="$3"

  if [[ "$expected_exit" == "$actual_exit" ]]; then
    smoke_pass "$label"
  else
    smoke_fail "$label (expected exit $expected_exit, got $actual_exit)"
  fi
}

smoke_summary() {
  echo
  echo "smoke: $SMOKE_PASS passed, $SMOKE_FAIL failed"
  if [[ "$SMOKE_FAIL" -gt 0 ]]; then
    return 1
  fi
  return 0
}
