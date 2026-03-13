# COR-1: Task Management

**Goal:** Enable teams to create, assign, prioritize, and track tasks as the foundation of all project workflows.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Task model | Data structure for tasks with required fields including title, status, project association, and optional metadata |
| Task creation | Ability to create new tasks and persist them to storage |
| Task retrieval | Ability to list and query tasks by project with pagination support |
| Task update | Ability to modify task properties including title, status, and metadata |
| Task deletion | Ability to remove tasks from the project |
| Assignment | Ability to assign tasks to team members and reassign them |
| Prioritization | Ability to set and update task priority with ordering support |
| Filtering | Ability to filter tasks by status, assignee, priority, and other criteria |

## Exit Criteria

- A task can be created, persisted, and retrieved in a subsequent session
- Tasks can be filtered by status, assignee, and priority with correct results
- A task can be assigned to a team member and the assignment persists
- Task priority affects sort order when listing tasks
- A task can be updated and deleted; changes persist and deletions remove the task from queries
