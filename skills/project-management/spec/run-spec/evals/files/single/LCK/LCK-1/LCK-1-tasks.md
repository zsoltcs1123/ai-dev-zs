# Task Plan: LCK-1 Link Extraction

## Summary

Decomposes the link extraction feature into five tasks: define the link record schema and extractor API, implement inline link extraction, implement reference definition parsing, implement reference link extraction with resolution, and handle edge cases (multi-line links, zero links, malformed syntax).

| # | Item | Type | Depends on | Status |
| --- | --- | --- | --- | --- |
| [1](#1-define-link-record-schema-and-extractor-api) | Define link record schema and extractor API | Task | None | |
| [2](#2-implement-inline-link-extraction) | Implement inline link extraction | Task | 1 | |
| [3](#3-implement-reference-definition-parsing) | Implement reference definition parsing | Task | 1 | |
| [VC1](#vc1-validation-checkpoint-inline-and-reference-definitions) | Validation Checkpoint: Inline and reference definitions | Validation Checkpoint | 2, 3 | |
| [4](#4-implement-reference-link-extraction) | Implement reference link extraction | Task | 2, 3 | |
| [5](#5-handle-edge-cases-and-robustness) | Handle edge cases and robustness | Task | 4 | |

## Tasks & Validation Checkpoints

### 1. Define link record schema and extractor API

Define the output format for extracted links and the public interface of the link extractor module. Each link record must include source file path, 1-based line number, and target URL or path.

**Steps:**
1. Define the link record structure with fields for file path, line number (1-based), and target
2. Define the extractor function signature that accepts file path and content and yields link records
3. Document the API contract and any invariants (e.g., line numbers always 1-based)

**Implementation requirements:**
- Link record exposes file path, line number, and target as accessible fields
- Extractor yields or returns an iterable of link records
- Line numbers are 1-based (first line of file is 1)

**Test coverage:**
- Link record construction — unit tests; schema is foundational for all extraction
- Extractor API contract — unit tests; ensures callers receive expected shape

**Verification scenarios:**
- Construct a link record with path, line, target — all fields are present and correctly typed
- Call extractor with empty content — yields empty sequence (no error)

**Depends on:** None

---

### 2. Implement inline link extraction

Parse markdown content and extract inline links using the `[text](target)` syntax. Yield link records with correct file path and line number for each match.

**Steps:**
1. Implement pattern matching for inline link syntax `[text](target)` where target is URL or path
2. Track line number for each match (1-based, from start of content)
3. Yield link records with file path, line number, and target for each inline link found
4. Handle target extraction (capture the URL/path between parentheses)

**Implementation requirements:**
- Inline link pattern matches `[text](target)` with non-empty target
- Each yielded record includes the source file path passed to the extractor
- Line numbers correspond to the line where the link starts

**Test coverage:**
- Inline link extraction — unit tests; core parsing logic with varied inputs
- Location tracking — unit tests; line numbers must be accurate for downstream consumers

**Verification scenarios:**
- File with one inline link — yields single record with correct target and line number
- File with multiple inline links on different lines — yields one record per link with correct line numbers
- File with multiple inline links on same line — yields multiple records, all with same line number

**Depends on:** 1

---

### 3. Implement reference definition parsing

Parse markdown content for reference definitions in the form `[ref]: target` (and optional title). Build a map of reference identifiers to resolved targets for use by reference link extraction.

**Steps:**
1. Implement pattern matching for reference definition syntax `[ref]: target` and `[ref]: target "title"`
2. Extract reference identifier and target from each match
3. Normalize reference identifiers (case-insensitive per CommonMark; collapse whitespace)
4. Build and return a map from normalized ref to target

**Implementation requirements:**
- Reference definitions follow `[ref]: target` syntax; optional title in quotes is supported
- Map keys are normalized (case-insensitive, trimmed)
- Map is built before reference link extraction runs (definitions typically appear earlier in file)

**Test coverage:**
- Reference definition parsing — unit tests; resolution correctness depends on this
- Implicit reference (link text equals ref when ref omitted) — unit tests if supported

**Verification scenarios:**
- File with reference definitions — map contains each ref with correct target
- Reference definitions with titles — target is extracted correctly, title optional
- Case variations in ref — map normalizes to single key

**Depends on:** 1

---

### VC1. Validation Checkpoint: Inline and reference definitions

**After tasks:** 2, 3

**What to validate:** Inline link extraction and reference definition parsing work independently and produce correct output before reference link resolution is implemented.

**Validation scenarios:**

- Parse a file with only inline links — yields link records with correct targets and line numbers
- Parse a file with only reference definitions — yields a complete ref-to-target map
- Parse a file with both — inline links extracted and reference definitions available for resolution

---

### 4. Implement reference link extraction

Parse reference-style links `[text][ref]` and resolve them to their targets using the reference definition map. Yield link records with correct file path, line number, and resolved target.

**Steps:**
1. Implement pattern matching for reference link syntax `[text][ref]` and shorthand `[ref][]`
2. For each match, look up the reference identifier in the definition map
3. If resolved, yield a link record with file path, line number, and resolved target
4. If unresolved, skip or handle according to policy (skip without crashing)

**Implementation requirements:**
- Reference link pattern matches `[text][ref]` and shorthand `[ref][]` (implicit ref)
- Ref lookup uses same normalization as definition map (case-insensitive)
- Unresolved references do not cause a crash; they are skipped

**Test coverage:**
- Reference link resolution — unit tests; integration with definition map
- Unresolved reference handling — unit tests; robustness

**Verification scenarios:**
- File with `[text][ref]` and matching definition — yields record with resolved target and correct line number
- File with shorthand `[ref][]` (implicit ref) — yields record with resolved target
- File with undefined reference — no crash; link is skipped or yields empty

**Depends on:** 2, 3

---

### 5. Handle edge cases and robustness

Handle multi-line links without losing location accuracy, files with zero links (empty result), and malformed link syntax (unmatched brackets) — skip invalid patterns without crashing.

**Steps:**
1. Extend inline link parsing to support target spanning multiple lines (e.g., target wrapped across lines)
2. Ensure extractor returns empty result (not error) when file has zero links
3. Add defensive handling for malformed syntax — unmatched brackets, invalid nesting — skip without crashing
4. Preserve start-line location for multi-line links (report line where link begins)

**Implementation requirements:**
- Multi-line link targets are supported; location is the line where the link starts
- Zero links produce an empty iterable, never an error or exception
- Malformed input (unmatched `[`, `]`, `(`, `)`) does not raise; invalid patterns are skipped

**Test coverage:**
- Multi-line link extraction — unit tests; location accuracy
- Zero-link and malformed input — unit tests; robustness

**Verification scenarios:**
- File with inline link whose target spans two lines — yields record with correct target and start line number
- File with no links — yields empty result, no error
- File with malformed link `[text](unclosed` — no crash; malformed link skipped
- File with unmatched brackets `[text` — no crash; skipped

**Depends on:** 4

---
