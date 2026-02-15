# Task Detailing

Define implementation steps, acceptance criteria, and dependencies for each task.

## Process

Walk through tasks in logical order. For each task:

### 1. Probe if Unclear

Before detailing, check if the task has enough information to define concrete steps.

**Probe when:**

- The task involves a decision that hasn't been made ("which auth provider?")
- The scope is ambiguous ("configure tools" — which tools?)
- There are multiple valid approaches with different implications

**Don't probe when:**

- The task is straightforward and well-understood
- Minor details can be assumed — state the assumption and move on
- The user already provided enough context in the identification phase

**Rules:**

- One focused question per task, not a barrage
- Frame questions as "I'm assuming X — correct?" rather than open-ended
- If the user defers ("whatever you think"), make the call and note it

### 2. Define Implementation Steps

Break the task into 5-7 concrete actions. Each step should be:

- A specific action, not a vague phase
- Ordered within the task (step 2 builds on step 1)
- Verifiable — you can tell if it's done

**Good steps:** "Define the token schema with user FK, hash, and expiry columns"
**Bad steps:** "Handle the data layer"

#### Splitting Oversized Tasks

If a task exceeds the 7-step ceiling (defined in SKILL.md), split it along a natural seam:

1. Component boundary (frontend vs backend)
2. Layer boundary (data vs logic vs API)
3. Decision point (before vs after a key choice)

Return to identification (Step 2) to insert the new tasks in the correct position.

### 3. Define Acceptance Criteria

Consolidate the task's objectives into a short bullet list of verifiable outcomes. Criteria should be:

- Observable (can be tested or demonstrated)
- Specific (not "works correctly" but "returns 200 for valid input, 401 for expired tokens")
- Complete (covers the task's full scope, including error cases when relevant)
- **Not a restatement of the implementation steps** — criteria describe *what success looks like*, not *how to get there*

### 4. Record Dependencies

Note which prior tasks this one depends on. Use task numbers from the identification phase. If a task has no dependencies, mark "None".

## Examples

### Good: "Add user password reset flow"

```
### Task 1: Create password reset token model
Add a database model to store reset tokens with expiry and user reference.

Steps:
1. Define the token schema (user FK, token hash, expires_at, used flag)
2. Create and run the migration
3. Add model-level validation and expiry check method

Acceptance criteria:
- Migration runs and model is queryable
- Expired tokens are identifiable without application logic

Depends on: None

---

### Task 2: Implement reset request endpoint
Endpoint accepts an email, generates a token, and queues a notification.

Steps:
1. Create the route and controller
2. Add token generation logic (secure random, hashed storage)
3. Queue email notification with reset link
4. Ensure response is identical for existing and non-existing emails

Acceptance criteria:
- POST /reset-password returns 200 regardless of whether the email exists
- Valid email produces a persisted token and a queued notification

Depends on: 1

---

### Task 3: Implement reset confirmation endpoint
Endpoint accepts token and new password, validates, and updates the password.

Steps:
1. Create the route and controller
2. Validate token (exists, not expired, not used)
3. Update user password and mark token as used
4. Invalidate any other active tokens for the user

Acceptance criteria:
- Valid token + new password updates the user's password
- Expired or used tokens return an error
- All other active tokens for the user are invalidated after a successful reset

Depends on: 1
```

### Anti-example: Too coarse

```
### Task 1: Implement password reset
Build the full password reset flow.

Acceptance criteria:
- Users can reset their password via email
```

Problem: combines data modeling, two endpoints, email integration, and security concerns. Cannot be completed or reviewed as a focused unit.

### Anti-example: Too granular

```
Task 1: Create migration file
Task 2: Add columns to migration
Task 3: Run migration
Task 4: Create model file
Task 5: Add validations to model
Task 6: Create route file
Task 7: Add POST route
Task 8: Create controller file
...
```

Problem: individual tasks are trivial and lack standalone value. These are implementation steps within a task, not tasks themselves.
