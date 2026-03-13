# COR-1: Task Management

**Goal:** Enable teams to create, assign, prioritize, and track tasks as the foundation of all project workflows.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Task model | Data structure for tasks with required fields including title, status, project association, and optional metadata |
| Task CRUD | Create, read, update, and delete operations for tasks with persistence |
| Assignment | Assign tasks to team members and reassign them |
| Prioritization | Set and update task priority with ordering support |
| Filtering | Filter tasks by status, assignee, priority, and other criteria |

## Exit Criteria

- A task can be created, persisted, and retrieved in a subsequent session
- Tasks can be filtered by status, assignee, and priority with correct results
- A task can be assigned to a team member and the assignment persists
- Task priority affects sort order when listing tasks
- A task can be updated and deleted; changes persist and deletions remove the task from queries
