# LCK-1: Link Extraction

**Goal:** Extract all markdown links from a set of files with accurate source location tracking.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Link extractor module | Parses markdown files and yields link records with file path, line number, and target |
| Inline link support | Extracts `[text](target)` syntax links |
| Reference link support | Extracts `[text][ref]` and resolves reference definitions |
| Location tracking | Every extracted link includes source file path and 1-based line number |

## Exit Criteria

- Inline links (`[text](url)`) are extracted with correct file path and line number
- Reference-style links (`[text][ref]`) are resolved to their target and extracted
- Links spanning multiple lines are handled without losing location accuracy
- A file with zero links produces an empty result, not an error
- Malformed link syntax (unmatched brackets) is skipped without crashing
