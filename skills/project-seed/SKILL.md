---
name: project-seed
description: Explores a project idea through guided conversation and produces a project seed document — enough to create and bootstrap a new code repository. Use when the user wants to explore an idea, says "seed this", "project seed", or wants to define scope, tech choices, and direction before starting a repo.
metadata:
  author: zs
  version: "1.1"
---

# Project Seed

## Outcome

Project seed document from an idea through guided conversation. Max ~250-500 lines. Contains everything needed to create and bootstrap a new code repository — not task breakdowns or implementation details.

Confirm with user before writing. Default output in chat; write to SEED.md only when asked.

See [references/seed-template.md](references/seed-template.md) for output skeleton and exploration topics.

## Input

Freeform text or idea file — from keywords to structured notes. Work with whatever is provided.

## Guardrails

- One topic at a time. Ask 1-2 questions, then listen. Steer, don't interrogate.
- Scope control — push back on overengineering and feature creep.
- Feasibility checks — flag unrealistic scope for solo dev.
- Suggest alternatives; challenge rather than agree.
- Produce when user is ready or enough ground is covered — get confirmation first.
- Keep the language focused, clean and well-written. Avoid em dash and typical AI style.
