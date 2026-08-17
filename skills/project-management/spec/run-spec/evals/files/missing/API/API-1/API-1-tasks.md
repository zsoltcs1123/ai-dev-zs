# Task Plan: REST Endpoints (API-1)

## Summary

Expose task management operations through a RESTful HTTP API with CRUD endpoints, filtered listing with pagination, consistent error responses, and request body validation.

| # | Item | Type | Depends on | Status |
| --- | --- | --- | --- | --- |
| [1](#1-establish-error-response-contract) | Establish error response contract | Task | None | |
| [2](#2-implement-request-validation) | Implement request validation | Task | None | |
| [3](#3-implement-task-crud-endpoints) | Implement task CRUD endpoints | Task | 1, 2 | |
| [4](#4-implement-filtered-listing-with-pagination) | Implement filtered listing with pagination | Task | 3 | |

## Tasks & Validation Checkpoints

### 1. Establish error response contract

Define a consistent error response shape used by all endpoints — status code, message, and optional structured details for validation errors. Ensures clients receive predictable error payloads.

**Steps:**
1. Define the error response schema (status, message, optional details/errors array)
2. Create a shared error response builder or formatter used by all route handlers
3. Wire the formatter into the global error handler or middleware so unhandled errors use the contract

**Implementation requirements:**
- All error responses use the same JSON structure with at least status code and message fields
- Validation errors include a structured details array (e.g., field-level errors) when applicable
- No endpoint returns raw stack traces or unstructured error bodies to clients

**Test coverage:**
- Error response formatter — unit tests; ensures consistent shape across error types
- Integration with route handlers — integration tests; verifies errors flow through the contract

**Verification scenarios:**
- Any endpoint returning an error — response body matches the defined schema with status and message
- Validation error — response includes structured details array with field-level messages
- Unhandled exception — returns 500 with generic message, no stack trace in body

**Depends on:** None

---

### 2. Implement request validation

Add request body validation for POST and PUT payloads with clear error messages for invalid or malformed input. Invalid payloads must return 400 with the structured error response.

**Steps:**
1. Define the task request schema (required and optional fields, types, constraints)
2. Add validation middleware or per-route validation for POST and PUT
3. Map validation failures to the error response contract with field-level messages
4. Ensure malformed JSON returns 400 with a clear message

**Implementation requirements:**
- POST and PUT handlers validate request body before processing
- Validation errors return 400 with the structured error response shape from task 1
- Each invalid field produces a clear, actionable error message
- Malformed or non-JSON bodies are rejected with a consistent error format

**Test coverage:**
- Validation logic — unit tests; covers required fields, types, and constraints
- End-to-end validation — integration tests; invalid payloads return 400 with correct shape

**Verification scenarios:**
- Valid payload — passes validation and proceeds to handler
- Missing required field — returns 400 with field name and message in details
- Invalid type (e.g., string for number) — returns 400 with clear type error
- Malformed JSON — returns 400 with parse error message
- Empty body on POST — returns 400 with validation error

**Depends on:** 1

---

### 3. Implement task CRUD endpoints

Implement POST (create), PUT (update), and DELETE (remove) for tasks at `/api/tasks` and `/api/tasks/:id`. POST returns 201 with the created resource; PUT returns 200; DELETE returns 204.

**Steps:**
1. Implement POST `/api/tasks` — accept validated body, persist task, return 201 with created resource
2. Implement PUT `/api/tasks/:id` — accept validated body, update existing task, return 200 with updated resource
3. Implement DELETE `/api/tasks/:id` — remove task by id, return 204 with no body
4. Handle not-found for PUT and DELETE (return 404 with error contract)
5. Ensure POST response includes Location header when applicable

**Implementation requirements:**
- POST returns 201 and includes the created task in the response body
- PUT returns 200 with the updated task; 404 when task does not exist
- DELETE returns 204 with empty body; 404 when task does not exist
- All success responses use a consistent resource representation
- Id parameter validation (e.g., invalid id format) returns 400

**Test coverage:**
- Create, update, delete logic — unit tests; persistence and id handling
- Endpoint integration — integration tests; full request/response cycle, status codes, body shape

**Verification scenarios:**
- POST with valid payload — returns 201, body contains created task with id
- POST with valid payload — created task is persisted and retrievable
- PUT with valid payload and existing id — returns 200, task updated
- PUT with non-existent id — returns 404 with error contract
- DELETE with existing id — returns 204, task no longer exists
- DELETE with non-existent id — returns 404 with error contract
- Invalid id format in path — returns 400 with validation error

**Depends on:** 1, 2

---

### 4. Implement filtered listing with pagination

Implement GET `/api/tasks` with query parameters for status and assignee filtering, plus pagination. Returns a paginated list of tasks.

**Steps:**
1. Implement GET `/api/tasks` base handler returning all tasks
2. Add query parameter parsing for status and assignee filters
3. Apply filters to the query before execution
4. Add pagination parameters (e.g., page, limit or offset, limit)
5. Return paginated response with items array and metadata (total count, page info)

**Implementation requirements:**
- GET supports optional `status` and `assignee` query parameters
- Pagination uses consistent parameters (e.g., `page` and `limit` or `offset` and `limit`)
- Response includes the list of tasks and pagination metadata
- Invalid or unsupported query values return 400 or are ignored per product decision (document behavior)
- Empty filter returns all tasks (subject to pagination)

**Test coverage:**
- Filter and pagination logic — unit tests; correct query construction
- Endpoint integration — integration tests; filters and pagination produce expected subsets

**Verification scenarios:**
- GET without params — returns paginated list (default page size)
- GET with status filter — returns only tasks matching status
- GET with assignee filter — returns only tasks matching assignee
- GET with both filters — returns tasks matching both
- GET with pagination params — returns correct page and page size
- GET with invalid filter value — returns 400 or documented fallback behavior
- Empty result set — returns empty array with correct pagination metadata

**Depends on:** 3
