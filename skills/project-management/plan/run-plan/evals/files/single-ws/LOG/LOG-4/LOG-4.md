# LOG-4: Frequency Analysis

**Goal:** Count and rank log entries by level, pattern, or field so developers identify the most common errors and trends.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Level aggregation | Count entries per log level (DEBUG, INFO, WARN, ERROR, FATAL) and output ranked by frequency |
| Message pattern aggregation | Group and count entries by message text or regex pattern so recurring error messages are identifiable |
| Field value aggregation | Count entries by a specified structured field (e.g., status code, error code) for custom breakdowns |
| Ranked output | Present aggregation results in descending order by count so the most frequent items appear first |
| Filter integration | Run frequency analysis on the filtered stream so users can scope analysis (e.g., errors only, specific time range) |
| Streaming aggregation | Compute counts incrementally as entries flow through the pipeline without loading the full dataset into memory |

## Dependencies

- [LOG-1](../LOG-1/LOG-1.md) — Requires parsed and structured log entries to aggregate

## Exit Criteria

- User can run a command and receive a frequency summary (e.g., by level) with counts ranked from highest to lowest
- User can identify the most common error message or message pattern from a log file
- User can get frequency breakdown by a custom field (e.g., HTTP status code) when that field exists in the log structure
- Frequency summary completes within 60 seconds for typical production log files (per vision metric)
