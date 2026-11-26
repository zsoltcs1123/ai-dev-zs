---
name: program-design
description: Change-scoped program design: code shape, types, call flow, file layout, vertical slices.
disable-model-invocation: true
metadata:
  author: zs
  version: "1.4"
---

# Program Design

## Outcome

A change-scoped program design in chat, including slice strategy, scaled to the change.

Done when the program-design guide's output checklist is complete: every row present. A reader can name code shape, key types and signatures, call flow, file layout, import-level inward dependencies, and an ordered vertical slice plan where each slice is testable end-to-end.

## Constraints

- **Change-scoped.** One feature or change.
- **Structure only.** Signatures and layout. Implementation bodies come later.
- Unclear system boundaries: settle them at system abstraction before writing.
- Size first. Small: stop; implement. Any other size: write the spec. Write only after the user agrees.
- Steer: 1-2 questions, then wait. Vague input: name this change's goals and deliverables before designing.
- Reply in chat. Write a file only when asked.
- Recorded decisions bind. Surface conflicts; the user decides.
- Write the spec. The guide is the bar, not the output.

## Tools

- Quality bar: [references/program-design-guide.md](references/program-design-guide.md). Load before writing.
- Change description with goals and deliverables: ticket, issue, feature brief, conversation, or product section.
- Existing docs when present.
