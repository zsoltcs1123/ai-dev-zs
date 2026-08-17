# LCK-2: Internal Link Checks

**Goal:** Verify that relative file paths and anchors resolve to existing targets so internal link rot is caught before readers encounter it.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Path resolution | Relative paths resolved correctly from each source file's location |
| File existence check | Target file verified to exist on disk |
| Anchor validation | Fragment (#anchor) validated against headings in the target file when present |
| Broken link detection | Internal links marked broken when target file or anchor is missing |
| Source context | Each result retains file path and line number for reporting |
| Directory traversal | Correct handling of parent and sibling paths (../, ./) |

## Dependencies

- [LCK-1](../LCK-1/LCK-1.md) — Links must be extracted before they can be checked

## Exit Criteria

- Internal links with valid target file and anchor pass validation
- Internal links with missing target file are reported as broken
- Internal links with invalid or missing anchor are reported as broken
- Relative paths resolve correctly regardless of source file depth
- No false positives for valid internal links
