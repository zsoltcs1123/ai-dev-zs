---
name: vibe-plan
description: Refines an idea into a high-level vibe plan through guided conversational exploration. Use when the user wants to explore a project idea, says "vibe plan this", "let's explore this idea", or wants to think through feasibility, scope, and tech choices before committing to a spec.
metadata:
  author: zs
  version: "1.1"
---

# Vibe Plan

## Outcome

High-level vibe plan from a project idea through guided conversation. Max ~250-300 lines. Not a spec — no implementation details, task breakdowns, or architecture decisions.

Confirm with user before writing. Default output in chat; write to file only when asked.

See [references/vibe-plan-template.md](references/vibe-plan-template.md) for output skeleton and exploration topics.

## Guardrails

- One topic at a time. Ask 1-2 questions, then listen. Steer, don't interrogate.
- Scope control — push back on overengineering and feature creep.
- Feasibility checks — flag unrealistic scope for solo dev.
- Suggest alternatives; challenge rather than agree.
- Produce when user is ready or enough ground is covered — get confirmation first.
- Keep the language focused, clean and well-written. Avoid em dash and typical AI style.
