# LCK-4: Broken Link Reporting

**Goal:** Present broken links with file path, line number, and target so authors can locate and fix issues quickly.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Aggregated broken-link list | Single report combining internal and external check results into one consumable output |
| Summary output mode | Human-readable output grouped by file, one line per broken link with line number and target |
| JSON output mode | Structured output for programmatic consumption |
| Exit code signaling | Nonzero exit code when any broken links are found; zero when all links are valid |
| Link type indication | Each reported link clearly labeled as internal or external |

## Dependencies

- [LCK-2](../LCK-2/LCK-2.md) — Internal check results feed into the report
- [LCK-3](../LCK-3/LCK-3.md) — External check results feed into the report

## Exit Criteria

- Running the tool on a directory with broken links produces a report listing each broken link with its source file, line number, and target
- Summary mode output is grouped by file and readable at a glance
- JSON mode output is valid and parseable by standard tools
- Exit code is nonzero when broken links exist and zero when none exist
- Authors can locate and fix each reported link without additional tooling
