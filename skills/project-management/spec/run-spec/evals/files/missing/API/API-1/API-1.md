# API-1: REST Endpoints

**Goal:** Expose task management operations through a RESTful HTTP API.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Task endpoints | CRUD endpoints for tasks at `/api/tasks` |
| Query endpoints | Filtered listing with pagination at `/api/tasks?status=...&assignee=...` |
| Error responses | Consistent error response shape with status codes and messages |
| Input validation | Request body validation with clear error messages for invalid payloads |

## Exit Criteria

- POST `/api/tasks` creates a task and returns 201 with the created resource
- GET `/api/tasks` returns a paginated list filtered by query parameters
- PUT `/api/tasks/:id` updates a task and returns 200
- DELETE `/api/tasks/:id` removes a task and returns 204
- Invalid payloads return 400 with a structured error response
