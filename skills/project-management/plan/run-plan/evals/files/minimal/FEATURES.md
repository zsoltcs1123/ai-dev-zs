# Feature Map

## Workstreams

| Code | Workstream | Features |
| ---- | ---------- | -------- |
| LCK  | Link Checking | 4 |

## LCK — Link Checking

| Code  | Feature              | Goal                                                                                     |
| ----- | -------------------- | ---------------------------------------------------------------------------------------- |
| [LCK-1](LCK/LCK-1/LCK-1.md) | Markdown Scanning    | Recursively discover and extract all links from markdown files so no link goes unchecked  |
| [LCK-2](LCK/LCK-2/LCK-2.md) | Internal Link Checks | Verify that relative file paths and anchors resolve to existing targets so internal link rot is caught before readers encounter it |
| [LCK-3](LCK/LCK-3/LCK-3.md) | External Link Checks | Validate external URLs via HTTP requests so dead or moved links are identified automatically |
| [LCK-4](LCK/LCK-4/LCK-4.md) | Broken Link Reporting| Present broken links with file path, line number, and target so authors can locate and fix issues quickly |
