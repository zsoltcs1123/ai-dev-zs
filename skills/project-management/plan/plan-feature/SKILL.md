---
name: plan-feature
description: Defines or updates a feature with goal, deliverables, and exit criteria. Use when the user says "plan feature", "define a feature", "add a feature", or wants to specify what a unit of work delivers.
metadata:
  author: zs
  version: "2.0"
---

# Plan Feature

Guide the user through defining a feature — the atomic unit of planned work. A feature has a clear goal, concrete deliverables, and observable exit criteria.

This is a **high-abstraction** document. Features describe _what_ gets delivered and _why it matters_ — not implementation detail.

## Input

Freeform — files, conversation context, codebase references, or any combination.

The skill also needs one piece of context that it cannot invent:

- **Feature code** (`{WS}-{N}`) — the user, an orchestrator, or `plan-features` output must provide this.

If missing, ask for it before producing the spec.

## Mode

**Generative.** Upstream docs contain the needed context. Read inputs, produce output, present it. Do not start a conversation. Only ask if the inputs are genuinely ambiguous or contradictory — resolve the specific issue, then generate.

## Procedure

### Step 1: Classify and resolve input

**Classify the input (in priority order):**

1. **Actionable feature definition** — enough context to define goal, deliverables, and exit criteria. Proceed to Step 2.
2. **Actionable but underspecified** — recognizably a feature but missing key decisions. Generate a best-effort spec with assumptions noted, or ask to resolve specific ambiguities. Then proceed to Step 2.
3. **Feature update** — input includes an existing feature spec plus what changed. Read the existing spec, apply changes while maintaining the feature structure. Present the updated spec in chat. Stop.
4. **Not a feature** — too granular (that's a task), too broad (a full project), a question, or off-topic. Respond helpfully, explain what this skill produces, and stop.

### Step 2: Produce the feature spec

Write the spec following the output structure in [references/plan-feature.md](references/plan-feature.md).

Present in chat. Write to file only if the user asks.

## Stance

Challenge vague deliverables. Ensure exit criteria are observable and verifiable. Push back on features that are too large (>10 deliverables — split them) or too small (<2 deliverables — that's just a task).

**Avoid:**

- Code snippets, file names, directory paths
- Deliverables that are vague or unmeasurable ("improve performance")
- Exit criteria phrased as tasks ("write tests") — must be observable outcomes ("all health checks pass")
- Features that overlap significantly with other features
