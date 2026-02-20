# Task Detailing

Define implementation steps, acceptance criteria, verification and validation scenarios, and dependencies for each task.

## Process

Walk through tasks in logical order. For each task:

### Define Implementation Steps

Break the task into up to 7 concrete actions. Each step should be:

- A specific action, not a vague phase
- Ordered within the task (step 2 builds on step 1)
- Verifiable — you can tell if it's done

**Abstraction level:** Steps should name _what_ to do and _which domain concepts_ are involved, not _where to put them_ or _how to wire them_. Include entity names, behaviors, and contracts. Omit file paths, module locations, full method signatures, and language-specific type constructs — the implementer decides those.

**Good steps:** "Define the token schema with user FK, hash, and expiry columns"
**Bad steps:** "Handle the data layer"
**Also bad:** "Create `packages/auth/src/models/token.py` with a `Token` class containing `user_id: int`, `token_hash: str`, `expires_at: datetime`" — too prescriptive about location and types

### Define Acceptance Criteria

Acceptance criteria are a quick done-check on the shape and existence of outputs. They answer _"did I produce the right thing?"_ — not _"does it handle edge cases?"_ (that's verification) or _"does it work when running?"_ (that's validation).

Consolidate the task's objectives into a short bullet list of verifiable outcomes. Criteria should be:

- Observable (can be tested or demonstrated)
- Specific (not "works correctly" but "returns 200 for valid input, 401 for expired tokens")
- Complete (covers the task's full scope)
- **Not a restatement of the implementation steps** — criteria describe _what success looks like_, not _how to get there_
- **Not test cases** — edge cases, error paths, and input variations belong in verification scenarios

**Anti-example:** criteria that are actually test cases:

```
Acceptance criteria:
- Expired token returns 400
- Used token returns 409
- Weak password returns 422
```

These exercise specific input variations — they belong in verification scenarios. The acceptance criterion here is: "Valid token + new password updates the password; invalid tokens are rejected."

### Define Verification Scenarios

Verification scenarios answer _"does the code work correctly?"_ They exercise code logic under varied inputs — happy paths, error cases, and boundary conditions. Each scenario is a specific input/condition paired with an expected behavior.

**Distinction from acceptance criteria:** Acceptance criteria confirm the right artifacts exist with the right shape ("endpoint exists and returns 200 for valid input"). Verification scenarios go deeper — they test behavior under varied, specific inputs ("expired token returns 400 with expiry error message").

#### Format

```
**Verification scenarios:**
- [input/condition] — [expected behavior]
- [input/condition] — [expected behavior]
```

#### Coverage

For each task, cover:

1. **Happy path** — the primary success case
2. **Error cases** — invalid input, missing data, unauthorized access
3. **Edge cases** — boundary values, empty inputs, concurrent access (when relevant)

Not every task needs all three. Use judgment — a simple config task may only need a happy path scenario. A security-sensitive endpoint needs thorough error and edge coverage.

#### Rules

- Each scenario must be specific enough to translate directly into a test case
- Name the input and the expected behavior — don't leave either vague
- Don't restate acceptance criteria as scenarios; go deeper
- Keep scenarios at the _what_ level — don't prescribe test framework, assertions, or setup code

#### Anti-example

Scenarios that restate acceptance criteria:

```
Verification scenarios:
- Migration runs successfully
- Model is queryable
```

These are acceptance criteria, not test cases. They confirm existence, not behavior under varied conditions.

#### Example

For a password reset confirmation endpoint:

```
Verification scenarios:
- Valid token + valid password — password is updated, token marked as used
- Expired token — returns error indicating token expiry
- Already-used token — returns error indicating token was consumed
- Valid token + password violating policy — returns password policy error, token remains unused
- Non-existent token — returns same error shape as expired token (no information leak)
- Concurrent reset with same token — only one succeeds, second gets "already used" error
```

### Define Validation Scenarios

Define behavioral checks against the **running software** to verify it works as an integrated system.

Validation scenarios answer _"does the software behave correctly when running?"_ Unlike verification (which tests isolated code), validation exercises the running system end-to-end. The agent (or a human) performs concrete actions against the live application and observes the results.

#### When to Generate

Only generate validation scenarios when the task produces **executable behavior**:

- API endpoint
- CLI command
- UI interaction
- Background job or scheduled task
- Message consumer
- Any interface a user or system can call

**Skip entirely** for tasks that don't produce runnable behavior: pure refactors, data model definitions without exposed interfaces, internal library code not yet consumed, configuration changes not yet wired up.

#### Format

```
**Validation scenarios:**
- [action against running system] — [expected observable result] — Automation: [full | partial | human-only]
```

#### Automation Levels

Each scenario must state its automation feasibility:

| Level          | Meaning                                              | Examples                                                                          |
| -------------- | ---------------------------------------------------- | --------------------------------------------------------------------------------- |
| **full**       | Agent can execute and verify end-to-end autonomously | curl an endpoint, run a CLI command, execute a throwaway script, query a database |
| **partial**    | Agent can invoke but a human must verify the outcome | Visual UI check, email content inspection, third-party side effect confirmation   |
| **human-only** | Requires manual interaction the agent cannot perform | OAuth redirect flow, physical device interaction, subjective quality judgment     |

#### Rules

- Each scenario must describe a concrete action, not an abstract check
- State the expected _observable_ result — what the agent or human should see
- Order scenarios from most critical to least critical
- Don't duplicate verification scenarios — validation checks integrated behavior, not unit logic

#### Example

For a password reset request endpoint:

```
Validation scenarios:
- Start the server, POST /reset-password with a registered email, verify 200 response and a token row in the database — Automation: full
- POST /reset-password with an unregistered email, verify 200 response and no token row created — Automation: full
- Submit a valid reset request, check that the notification email arrives in the test inbox with a valid reset link — Automation: partial (agent sends request, human confirms email content)
```

### Record Dependencies

Note which prior tasks this one depends on. Use task numbers from the identification phase. If a task has no dependencies, mark "None".

#### Examples

#### Good (no validation scenarios): "Add user password reset flow"

```
### Task 1: Create password reset token model
Add a database model to store reset tokens with expiry and user reference.

**Steps:**
1. Define the token schema (user FK, token hash, expires_at, used flag)
2. Create and run the migration
3. Add model-level validation and expiry check method

**Acceptance criteria:**
- Migration runs and model is queryable
- Expired tokens are identifiable without application logic

**Verification scenarios:**
- Create a token with future expiry — expiry check reports valid
- Create a token with past expiry — expiry check reports expired
- Create a token and mark as used — used flag persists and is queryable

---
```

#### Good (with validation scenarios): "Implement reset request endpoint"

```
### Task 2: Implement reset request endpoint
Endpoint accepts an email, generates a token, and queues a notification.

**Steps:**
1. Create the route and controller
2. Add token generation logic (secure random, hashed storage)
3. Queue email notification with reset link
4. Ensure response is identical for existing and non-existing emails

**Acceptance criteria:**
- POST /reset-password returns 200 regardless of whether the email exists
- Valid email produces a persisted token and a queued notification

**Verification scenarios:**
- Registered email — returns 200, token persisted, notification queued
- Unregistered email — returns 200, no token created, no notification queued
- Malformed email — returns 400 with validation error
- Two rapid requests for same email — each produces a distinct token

**Validation scenarios:**
- Start the server, POST /reset-password with a registered email, verify 200 response and token row in the database — Automation: full
- POST /reset-password with an unregistered email, verify 200 and no token created — Automation: full
- Submit a valid reset request, check that the notification email arrives in the test inbox with a valid reset link — Automation: partial (agent sends request, human confirms email content)

**Depends on:** 1

---
```
