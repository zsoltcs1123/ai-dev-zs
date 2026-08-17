# LOG-3: Request Correlation

**Goal:** Group log entries by request or trace ID so developers reconstruct the full lifecycle of a single request.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Request grouping | Collect all log entries for a given request or trace ID into a single correlated set |
| Chronological ordering | Order entries within each request by timestamp so the lifecycle is readable |
| Request lifecycle view | Present correlated entries in a format that shows the full flow of a single request from first to last log |
| Multi-ID field support | Recognize and correlate using request_id, trace_id, and X-Request-ID fields |
| Correlation output format | Output clearly groups entries by request with section headers or visual grouping |
| Partial request handling | Exclude entries without a request ID from correlation results; only entries with matching ID are returned |

## Dependencies

- [LOG-1](../LOG-1/LOG-1.md) — Requires parsed log entries with request ID fields

## Exit Criteria

- A user can specify a request ID and receive all log entries for that request, ordered by timestamp
- The output clearly shows the lifecycle of a single request from first to last log entry
- Correlation works with request_id, trace_id, and X-Request-ID fields
- Entries without a request ID are excluded from correlation results
- Time to isolate a request's log entries is under 10 seconds
