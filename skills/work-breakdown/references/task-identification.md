# Task Identification

Extract, validate, and order the full list of tasks from a unit of work.

## Process

### 1. Extract Task Candidates

Scan the input for distinct pieces of work. Look for:

- Explicit items the user listed
- Implicit work required by explicit items (e.g., "set up CI" implies configuring a runner, writing pipeline config, adding status checks)
- Setup/teardown work not mentioned but necessary
- Integration points between components

Create obvious tasks directly. Flag non-obvious ones for probing.

### 2. Probe for Missing Tasks

Ask about work the user may not have considered:

- **Prerequisites**: "Does X need Y to exist first?"
- **Non-functional concerns**: Logging, monitoring, error handling, security, documentation
- **Edge cases**: "What happens when Z fails?"
- **Scope boundaries**: "Is W in scope or separate?"

**Rules:**

- Only probe for tasks that would materially change the breakdown
- Make educated assumptions on minor gaps — state them and move on
- Batch related probes into a single question rather than asking one at a time
- If the input is already thorough, skip or ask one clarifying question at most

### 3. Right-Size the List

Each task should be a single, coherent unit of work completable in a focused session.

| Signal | Too Big | Right-Sized | Too Granular |
| --- | --- | --- | --- |
| Duration | Multi-day effort | Focused session (hours) | Minutes of work |
| Scope | Multiple concerns | Single concern | Partial concern |
| Description | Needs sub-breakdown | Self-contained | Trivial / obvious |
| Steps needed | >7 implementation steps | 3-7 steps | 1-2 steps or none |
| Review | Hard to review as one unit | Reviewable as one unit | Not worth a standalone review |

**If a candidate is too big:** split along natural seams — by component, by layer, by concern.
**If candidates are too granular:** merge related ones into a single coherent task.

### 4. Order Logically

Arrange tasks so that:

1. **Foundation first** — infrastructure, setup, data models before features
2. **Dependencies respected** — no task references something a later task creates
3. **Progressive building** — each task builds on prior work toward a working whole
4. **Integration points grouped** — tasks that connect components sit near each other

When two tasks have no dependency, prefer the order that gives earlier feedback or reduces risk.

### 5. Apply the 20-Task Guardrail

If the list exceeds 20 tasks, do not proceed to detailing. Present the situation and suggest:

- **Group into milestones** — cluster related tasks under milestone headings
- **Split into sub-epics** — break the work into 2-4 smaller units, each getting its own breakdown
- **Revisit scope** — some work may belong in a future phase

Ask the user which approach they prefer.

### 6. Validate and Present

Before moving to detailing, check:

- [ ] No gaps — completing all tasks delivers the full scope
- [ ] No overlaps — each piece of work lives in exactly one task
- [ ] Logical ordering holds — no forward dependencies
- [ ] Total count is ≤20
- [ ] Each task is right-sized (single concern, focused session)

Present the task list in compact format:

```
1. [Title] — [one-line description] (depends on: None)
2. [Title] — [one-line description] (depends on: 1)
3. [Title] — [one-line description] (depends on: 1, 2)
```

**Stop here. Do not proceed to detailing until the user confirms.**

The user may approve as-is, or request changes: reorder, merge, split, add, or remove tasks. If changes are requested:

1. Apply the modifications
2. Re-validate ordering, dependencies, and right-sizing
3. Present the updated list in the same format
4. Wait for confirmation again
