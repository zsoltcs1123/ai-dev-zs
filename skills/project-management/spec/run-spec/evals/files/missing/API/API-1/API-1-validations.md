# Validation Scenarios: API-1 REST Endpoints

## Summary

Validation scenarios for the API-1 REST endpoints feature. Scenarios verify task management CRUD operations, filtered listing with pagination, consistent error responses, and input validation against the running API.

## Exit Criteria Source

Feature spec: `.agents/skills/spec/run-spec/evals/files/missing/API/API-1/API-1.md`

## Automation Legend

- **(A)** — Agent-executable: can be validated via shell commands, HTTP requests, or browser interaction
- **(H)** — Human-only: requires commits, CI triggers, or external tooling

## Scenarios

### API-1-VS1. POST creates task and returns 201

**Validates:** POST `/api/tasks` creates a task and returns 201 with the created resource

**Scenarios:**
- **(A)** POST valid task payload to `/api/tasks` — returns 201, response body contains created task with id, Location header present when applicable
- **(A)** POST valid task — created task is persisted and returned by subsequent GET

---

### API-1-VS2. GET returns paginated filtered list

**Validates:** GET `/api/tasks` returns a paginated list filtered by query parameters

**Scenarios:**
- **(A)** GET `/api/tasks` without params — returns 200 with items array and pagination metadata
- **(A)** GET `/api/tasks?status=open` — returns only tasks with status matching filter
- **(A)** GET `/api/tasks?assignee=user1` — returns only tasks with assignee matching filter
- **(A)** GET `/api/tasks?page=1&limit=10` — returns correct page and page size
- **(A)** GET with both status and assignee — returns tasks matching both filters

---

### API-1-VS3. PUT updates task and returns 200

**Validates:** PUT `/api/tasks/:id` updates a task and returns 200

**Scenarios:**
- **(A)** PUT valid payload to `/api/tasks/:id` for existing task — returns 200, response body contains updated task
- **(A)** PUT to non-existent id — returns 404 with structured error response
- **(A)** PUT with invalid id format — returns 400 with validation error

---

### API-1-VS4. DELETE removes task and returns 204

**Validates:** DELETE `/api/tasks/:id` removes a task and returns 204

**Scenarios:**
- **(A)** DELETE existing task by id — returns 204 with empty body, task no longer exists on subsequent GET
- **(A)** DELETE non-existent id — returns 404 with structured error response

---

### API-1-VS5. Invalid payloads return 400 with structured error

**Validates:** Invalid payloads return 400 with a structured error response

**Scenarios:**
- **(A)** POST with missing required field — returns 400, body has status, message, and structured details
- **(A)** POST with invalid type (e.g., string for number) — returns 400 with clear validation error
- **(A)** POST with malformed JSON — returns 400 with parse error message
- **(A)** PUT with invalid payload — returns 400 with structured error response
- **(A)** Any error response — body matches defined schema (status, message, optional details)

---

## Execution Notes

**Prerequisites:** API server running and reachable (e.g., `http://localhost:3000` or configured base URL). Adjust host and port per project configuration.

**Ordering:** Create tasks (VS1) before testing filters (VS2). Run update (VS3) and delete (VS4) against created tasks. Validation scenarios (VS5) can run in any order.

**Tools:** Use `curl`, `httpie`, or similar for agent-executable scenarios. Ensure test data is isolated or cleaned between runs to avoid cross-test pollution.
