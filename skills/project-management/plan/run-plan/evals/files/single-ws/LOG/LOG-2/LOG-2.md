# LOG-2: Structured Queries

**Goal:** Enable filtering by level, time range, request ID, and field values so developers isolate relevant entries in a single command.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Level filter | Filter entries by one or more log levels (e.g. error, warn) |
| Time range filter | Filter entries by timestamp within a given after/before range |
| Request ID filter | Filter entries that match a specified request or trace ID |
| Field value filter | Filter entries where a structured field equals a given value |
| Message pattern filter | Filter entries whose message matches a text or regex pattern |
| Composable filters | Combine multiple filters so all conditions must match |
| CLI integration | Expose filters as command-line options that accept user input |
| Streaming behavior | Apply filters entry-by-entry without loading the full file into memory |

## Dependencies

- [LOG-1](../LOG-1/LOG-1.md) — Parsed log entries must be available before they can be queried

## Exit Criteria

- A user can filter a log file by level and receive only entries at the specified levels
- A user can filter by time range and receive only entries within that window
- A user can filter by request ID and receive only entries belonging to that request
- A user can filter by field value (e.g. status=500) and receive only matching entries
- A user can filter by message pattern and receive only entries whose message matches
- A user can combine two or more filters and receive entries that satisfy all conditions
- Filtering completes without loading the entire file into memory for files up to 10 GB
