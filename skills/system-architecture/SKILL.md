---
name: system-architecture
description: System-scoped architecture: components, data, inward dependencies, tech stack as plugins. Use for "system architecture", "project architecture", or "design the architecture".
disable-model-invocation: true
metadata:
  author: zs
  version: "2.1"
---

# System Architecture

## Outcome

A system-scoped architecture spec in chat, scaled to the system.

Done when the architecture guide's output checklist is complete: every Always row present; every conditional row present when its trigger holds. A reader can name the system's components, how they interact, data architecture, inward dependencies, tech stack as plugins, decisions, and what is still unmade.

## Constraints

- **System-scoped.** The whole system, not a single feature or change.
- **System abstraction.** Not code shape, files, signatures, or version numbers.
- Needs a vision. Vague input: push back; do not design yet.
- Size first. Propose which include-when topics apply; write only after the user agrees.
- Steer: 1-2 questions, then wait.
- Reply in chat. Write a file only when asked.
- Recorded decisions bind. Surface conflicts; the user decides.
- Write the spec. The guide is the bar, not the output.

## Tools

- Quality bar: [references/architecture-guide.md](references/architecture-guide.md). Load before writing.
- Vision: problem statement, scope, and constraints.
- Existing docs when present.
