---
name: architecture
description: Change-scoped system architecture: components, contracts, data flows, inward dependencies.
disable-model-invocation: true
metadata:
  author: zs
  version: "1.4"
---

# Architecture

## Outcome

A change-scoped system architecture spec in chat, scaled to the change.

Done when the architecture guide's output checklist is complete: every Always row present; every conditional row present when its trigger holds. A reader can name the components this change touches, how they interact, what contracts and data change, and which dependencies point inward.

## Constraints

- **Change-scoped.** One feature or change.
- **System abstraction.** Components, contracts, data flows. Not code shape, files, or signatures.
- Size first. Small: stop; implement. Any other size: write the spec. Write only after the user agrees.
- Steer: 1-2 questions, then wait. Vague input: name this change's goals and deliverables before designing.
- Reply in chat. Write a file only when asked.
- Recorded decisions bind. Surface conflicts; the user decides.
- Write the spec. The guide is the bar, not the output.

## Tools

- Quality bar: [references/architecture-guide.md](references/architecture-guide.md). Load before writing.
- Change description with goals and deliverables: ticket, issue, feature brief, conversation, or product section.
- Existing docs when present.
