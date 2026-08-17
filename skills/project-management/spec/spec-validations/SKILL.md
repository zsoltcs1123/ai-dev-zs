---
name: spec-validations
description: Derives behavioral validation scenarios against running software from a feature or milestone's goals and exit criteria. Use when the user says "spec validations", "plan validations", "verify this milestone", "acceptance checks", or wants to define how to know a milestone is done.
metadata:
  author: zs
  version: "5.0"
---

# Spec Validations

Derive validation scenarios that verify a feature or milestone meets its stated goals and exit criteria against running software.

## Input

**Required:** A feature or milestone definition containing goals, deliverables, and/or exit criteria. Typically sourced from a roadmap milestone or feature spec. The feature code (`{WS}-{N}`) must be known — it prefixes all scenario IDs.

**Optional:** A detailed tasks plan. When provided, it is the richest source of concrete scenarios — mine its verification scenarios, validation checkpoints (VCs), and implementation requirements for specifics. When absent, derive from exit criteria, deliverables, and codebase inspection alone.

### Input Validation

- **No exit criteria**: push back — ask the user to define what "done" looks like before deriving validations.
- **Too vague** (e.g., "it should work"): push back — exit criteria must be concrete enough to verify.
- **No feature code**: push back — ask for the feature code so scenario IDs can be properly prefixed.
- **Right-sized**: a feature or milestone with clear goals and exit criteria. Proceed.

## Mode

**Generative.** Upstream docs contain the needed context. Read inputs, produce output, present it. Do not start a conversation. Only ask if the inputs are genuinely ambiguous or contradictory — resolve the specific issue, then generate.

## Context

MUST operate in codebase context. Inspect the codebase to discover actual service names, ports, endpoint paths, container names, config file paths, and existing infrastructure. Ground every scenario in these real details — no abstract placeholders.

## Procedure

Follow [references/derive-validations.md](references/derive-validations.md) to extract success conditions, derive scenarios, and produce the validation suite.

## Output

Use the document-level wrapper and per-scenario format defined in [references/derive-validations.md](references/derive-validations.md). Every scenario is tagged **(A)** (agent-executable) or **(H)** (human-only).

Scenario IDs must use the `{FEATURE}-VS{N}` format (e.g. `PLT-1-VS1`, `PLT-1-VS2`).
