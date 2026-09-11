---
name: adr
description: Draft an Architecture Decision Record. Use when the user says "new ADR", "write an ADR", "record a decision", or "/adr".
metadata:
  author: zs
  version: "2.0.0"
---

# ADR

## Outcome

A draft ADR in chat that conforms to [references/adrs.md](references/adrs.md) (format, sections, writing rules).

Done means: a reader grasps the decision in under two minutes, the convention is followed, and the decision (not a design essay) is what got recorded.

## Constraints

- Load [references/adrs.md](references/adrs.md) before drafting. Follow it; do not restate it here.
- Ask the user for anything you cannot infer: the decision, why now, alternatives weighed, consequences, status/date/scope, related ADRs.
- If the topic needs pages of design detail, say so and offer a separate spec. Put only the decision and links in the ADR.
- **Default: reply with the ADR in chat.** Do not write a file unless the user asks for one or names a path.
- When the user asks to save it, follow repo ADR conventions if they exist.
- Enhance an ADR with inline mermaid blocks if they help in understanding the topic.
