# LCK-3: External Link Checks

**Goal:** Validate external URLs via HTTP requests so dead or moved links are identified automatically.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| HTTP validation | External URLs checked via HTTP requests |
| Timeout handling | Requests time out after 5 seconds to avoid hanging on unresponsive hosts |
| Redirect following | 3xx redirects followed to final destination before validity assessment |
| HEAD with GET fallback | HEAD used by default; fallback to GET when server returns 405 |
| Concurrent batching | Up to 20 concurrent requests for throughput |
| Validity rules | 2xx responses treated as valid; non-2xx, timeout, and connection failure treated as broken |
| Source context | Each result retains file path, line number, and target URL for reporting |
| Broken link detection | External links marked broken when target is unreachable or returns error status |

## Dependencies

- [LCK-1](../LCK-1/LCK-1.md) — Links must be extracted before they can be validated

## Exit Criteria

- External links returning 2xx are not reported as broken
- External links returning 4xx or 5xx are reported as broken with file path, line number, and target
- External links that time out or fail to connect are reported as broken
- Redirects are followed; final 2xx counts as valid
- Valid external links produce no false positives in the broken-link report
