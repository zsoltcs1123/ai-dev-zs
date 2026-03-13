# Derive Validations

Produce validation scenarios from a feature or milestone's goals, exit criteria, and deliverables.

## Extract Success Conditions

Read the feature or milestone definition and identify every concrete success condition from three sources:

1. **Explicit exit criteria** (e.g., "docker compose up brings up entire stack")
2. **Deliverables with implied success conditions** — each deliverable row implies something must be running, reachable, or configured correctly
3. **Goals that imply observable behavior** (e.g., "All platform infrastructure components running and connected")

When a **tasks plan** is provided, also extract:

4. **Validation checkpoints (VCs)** — these are pre-defined integration checks between tasks
5. **Per-task verification scenarios** — concrete checks defined at the task level

If exit criteria are vague or missing, push back and ask the user to define them before proceeding.

## Inspect the Codebase

Before deriving scenarios, inspect the codebase to discover concrete details:

- Service names, container names, image tags
- Ports (exposed and internal)
- Endpoint paths (health, ready, metrics, API routes)
- Config file paths (Compose files, gateway config, monitoring config)
- Environment variable names and their sources (`.env`, `.env.template`)
- Existing scripts, tools, and conventions

Use these real values in every scenario. Never write abstract placeholders like "the service port" or "the health endpoint" — write `http://localhost:9090` or `/idx/health`.

## Derive Scenarios

For each success condition, derive one or more validation scenarios. Each scenario is an action against running software paired with an expected observable result.

### Rules

- Every exit criterion must be covered by at least one scenario
- Every deliverable must be covered by at least one scenario
- Scenarios must be executable against the running system — no code inspection, no "check that the file exists" (unless checking documentation/config presence is the exit criterion itself)
- State the specific action and the specific expected result — not "it works" but "curl http://localhost/auth/realms/master returns Keycloak realm JSON with /auth/ prefix in endpoint URLs"
- Ground scenarios in codebase specifics: real ports, service names, endpoints, container names, config paths
- Tag every scenario **(A)** or **(H)**:
  - **(A)** — Agent-executable: can be validated via shell commands, HTTP requests, browser interaction, or file inspection
  - **(H)** — Human-only: requires commits, CI triggers, or devcontainer lifecycle
- Group scenarios under the exit criterion they validate

### Coverage

For each success condition, consider:

1. **Primary verification** — the direct check that confirms the criterion is met
2. **Negative/boundary cases** — where the criterion implies them (e.g., "gateway routing" implies checking fault isolation when a backend is down)
3. **Task-level specifics** — when a tasks plan is provided, selectively incorporate per-task verification scenarios and VCs that add validation value beyond the exit-criteria scenarios. Mine them for concrete edge cases and integration checks; do not copy them verbatim. Skip task scenarios that are redundant with what's already covered.

The goal is full functional coverage without redundancy. Every exit criterion and deliverable must be validated. Don't leave gaps, but don't duplicate either.

### Format

Per-scenario format. Scenario IDs use the `{FEATURE}-VS{N}` convention (e.g. `PLT-1-VS1`) to be globally addressable:

```
### {FEATURE}-VS{N}. [Short descriptive name]
**Validates:** [which exit criterion]
**Scenarios:**
- **(A)** [action on running system] — [expected observable result]
- **(H)** [action on running system] — [expected observable result]
```

Document-level wrapper:

```
# Validation Scenarios: [Title]

## Summary
[1-2 sentences: what feature/milestone these validations cover and what the scenarios are executable against]

## Exit Criteria Source
[Reference to the milestone/feature definition]

## Automation Legend
- **(A)** — Agent-executable: can be validated via shell commands, HTTP requests, or browser interaction
- **(H)** — Human-only: requires commits, CI triggers, or external tooling

## Scenarios
[{FEATURE}-VS1, {FEATURE}-VS2, ... using per-scenario format above]

---

## Execution Notes
[Prerequisites for running agent-executable scenarios (tools, env setup, port availability)]
[Ordering recommendations (e.g., destructive scenarios last)]
[Notes on human-only scenarios (when/how to run them)]

## Cleanup
[Everything the suite may leave behind that must be removed or rolled back after the run completes.]
[Examples: temporary files/scripts, test data inserted into services, containers/processes started for validation, environment or config changes.]
[Omit this section if the entire suite is read-only.]
```

## Produce and Present

Produce the complete validation suite. Do not present a draft and wait for approval mid-way — produce the full output, then tell the user it's ready for review. The user may then:

- **Approve** — done
- **Add** — insert scenarios for uncovered criteria or edge cases
- **Remove** — drop scenarios that are redundant
- **Adjust** — change scope, actions, or expected results

Apply changes and re-present if requested.
