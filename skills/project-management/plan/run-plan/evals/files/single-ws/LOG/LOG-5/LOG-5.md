# LOG-5: Output Formatting

**Goal:** Render results as tables, JSON, or plain text so output integrates with both human reading and downstream tooling.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Table output mode | Aligned columns for terminal readability with timestamp, level, message, request ID, and key fields |
| JSON output mode | One JSON object per log entry for piping to jq or other tools |
| Plain text output mode | Raw message text, one per line, for minimal output |
| Format selection | CLI option to choose output format (table, json, plain) |
| Column configuration | Configurable columns for table mode so users show or hide fields |
| Terminal width awareness | Table output respects terminal width when available |
| Streaming output | Emit formatted output entry-by-entry without buffering the full result set |

## Dependencies

- [LOG-1](../LOG-1/LOG-1.md) — Requires parsed entries to format for output

## Exit Criteria

- A user can request table output and receive aligned, readable columns in the terminal
- A user can request JSON output and receive valid JSON objects suitable for piping to other tools
- A user can request plain output and receive raw message text only
- Output format can be selected via a CLI flag or option
- Table output adapts to terminal width when running in an interactive terminal
- Formatted output is emitted incrementally without loading the full result set into memory
