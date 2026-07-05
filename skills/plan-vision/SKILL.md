---
name: plan-vision
description: Produces the vision document for a project through guided conversation. Use when planning a new project, the user says "plan vision", "create a vision", or wants to define the problem, scope, and strategic direction.
metadata:
  author: zs
  version: "1.1"
---

# Plan Vision

Produce a VISION.md that defines the core problem, vision, and strategic direction for a project, through guided conversation.

A finished VISION.md is **specific and validated**: a clear problem statement (who has it, current pain), a vision with measurable success criteria, explicit scope boundaries, and named risks/constraints/assumptions where they matter. It is scaled to the project: a weekend project needs half a page; an enterprise system may need 5+. Once established, a vision should rarely change, only when the project itself changes substantially.

See [references/vision-reference.md](references/vision-reference.md) for the section reference and quality bar.

## Input

Flexible: freeform text, an idea file, or anything resembling a project description. Work with whatever is provided, however vague. If the input has too little substance to start (e.g., a single word with no context), push back and ask for more.

## Topics to cover

Not all apply to every project. Cover what's relevant:

- **Problem** — what specific problem, and who has it?
- **Vision & success** — what does success look like? How is it measured?
- **Scope** — what's in v1, what's out?
- **Constraints** — time/budget, technical limits, team size.
- Larger projects: business context, users & stakeholders, success metrics, risks.

## Guardrails

- **Conversational.** One topic at a time. Ask 1-2 questions, let the user answer, then move on. Steer, don't interrogate.
- **Confirm scope before writing.** Propose document depth ("This seems like a [simple tool / standard app / enterprise system]; I'd include [sections]. Sound right?") and get agreement.
- Present the vision in chat. Write to file only if the user asks.
- Challenge vague statements, validate assumptions, flag risks early, push back on scope creep.
- No buzzwords without definitions, no unmeasurable success criteria, no optional sections that add nothing, no over-documenting simple projects.
