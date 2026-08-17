# LCK-1: Markdown Scanning

**Goal:** Recursively discover all markdown files in a directory and extract every link from them so no link goes unchecked.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Directory walker | A recursive file scanner that discovers all markdown files in a given directory tree, respecting .gitignore patterns |
| Link extractor | A parser that extracts inline links and reference links from each markdown file, recording file path, line number, and link target |
| Link classification | Logic that categorizes each extracted link as internal (relative path) or external (HTTP URL) for routing to the appropriate checker |

## Exit Criteria

- Running the scanner on a directory with nested markdown files discovers all `.md` files recursively
- Every inline link `[text](target)` and reference link `[text][ref]` in each file is extracted with correct file path and line number
- Each extracted link is classified as internal or external
- Files and directories matching `.gitignore` patterns are excluded from scanning
