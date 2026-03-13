# Validation Scenarios: LCK-1 Link Extraction

## Summary

These scenarios verify that the LCK-1 link extractor module extracts all markdown links from files with accurate source location tracking. Scenarios are executable by invoking the extractor with markdown content and asserting on the yielded link records.

## Exit Criteria Source

Feature spec: `.agents/skills/spec/run-spec/evals/files/single/LCK/LCK-1/LCK-1.md`

## Automation Legend

- **(A)** — Agent-executable: can be validated via shell commands, test scripts, or direct module invocation
- **(H)** — Human-only: requires commits, CI triggers, or external tooling

## Scenarios

### LCK-1-VS1. Inline links extracted with correct location

**Validates:** Inline links (`[text](url)`) are extracted with correct file path and line number

**Scenarios:**

- **(A)** Invoke extractor on a markdown file containing `[Example](https://example.com)` on line 5 — yields one link record with target `https://example.com`, file path matching the input file, and line number 5
- **(A)** Invoke extractor on a file with inline links on lines 2, 7, and 12 — yields three records with line numbers 2, 7, and 12 respectively
- **(A)** Invoke extractor on a file with two inline links on the same line — yields two records, both with the same line number

---

### LCK-1-VS2. Reference-style links resolved and extracted

**Validates:** Reference-style links (`[text][ref]`) are resolved to their target and extracted

**Scenarios:**

- **(A)** Invoke extractor on a file with `[ref]: https://example.com` and `[link][ref]` — yields one link record with resolved target `https://example.com` and correct line number for the reference link
- **(A)** Invoke extractor on a file with shorthand `[ref][]` and definition `[ref]: /path` — yields one link record with resolved target `/path`
- **(A)** Invoke extractor on a file with reference link and case-variant definition `[Ref]: url` and `[text][ref]` — yields record with resolved target (case-insensitive match)

---

### LCK-1-VS3. Multi-line links preserve location accuracy

**Validates:** Links spanning multiple lines are handled without losing location accuracy

**Scenarios:**

- **(A)** Invoke extractor on a file with an inline link whose target spans two lines (e.g., long URL wrapped) — yields one record with correct concatenated target and line number equal to the line where the link starts
- **(A)** Invoke extractor on a file with reference definition spanning multiple lines — reference link using that ref yields correct resolved target and line number

---

### LCK-1-VS4. Zero links produce empty result

**Validates:** A file with zero links produces an empty result, not an error

**Scenarios:**

- **(A)** Invoke extractor on a markdown file with no links (plain text only) — yields empty sequence, no exception raised
- **(A)** Invoke extractor on empty file content — yields empty sequence, no exception raised

---

### LCK-1-VS5. Malformed syntax skipped without crash

**Validates:** Malformed link syntax (unmatched brackets) is skipped without crashing

**Scenarios:**

- **(A)** Invoke extractor on content with `[text](unclosed` — no exception; malformed link is skipped, yields empty or only valid links
- **(A)** Invoke extractor on content with `[text` (unmatched bracket) — no exception; invalid pattern skipped
- **(A)** Invoke extractor on content mixing valid `[ok](url)` and malformed `[bad` — yields record for valid link only, no crash

---

## Execution Notes

**Prerequisites:** The link extractor module must be implemented and importable. A test script or pytest invocation can run these scenarios by calling the extractor with fixture markdown content and asserting on the output.

**Ordering:** Scenarios can run in any order; each is independent. No destructive operations.

**Agent-executable flow:** Create temporary markdown files with the specified content, invoke the extractor, assert on yielded records. All scenarios are **(A)**.
