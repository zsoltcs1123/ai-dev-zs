---
name: plan-architecture
description: Produces the architecture document for a project. Use when the user says "plan architecture", "design the architecture", "create architecture", or wants to define technical structure, components, and technology choices.
metadata:
  author: zs
  version: "1.1"
---

# Plan Architecture

Produce an ARCHITECTURE.md defining high-level technical structure, components, and technology choices, through guided conversation.

This is a **high-abstraction** document: it describes _what_ the system is made of and _why_, not _how_ it's coded. Never include code examples, file names, directory paths, or specific version numbers; those belong in implementation specs and task plans.

A finished ARCHITECTURE.md names the main components and their responsibilities, the data architecture, the technology stack with rationale, and the key decisions with tradeoffs acknowledged. It is scaled to the project: a simple project needs 1-2 pages; an enterprise system may need 10+; only include sections that add value. Architecture is a living document, but changes should be controlled and deliberate; a good one rarely needs changing.

See [references/architecture-reference.md](references/architecture-reference.md) for the section reference and quality bar.

## Input

Requires a well-defined vision: a VISION.md or equivalent with clear problem statement, scope, and constraints. If the input is vague or insufficient, push back and help define the vision first before making architecture decisions.

## Topics to cover

Not all apply to every project. Cover what's relevant:

- **Components** — what are the main components, and how do they interact?
- **Data** — what flows through the system, and where is it stored?
- **Tech stack** — what technologies, and why?
- Larger projects: alternatives considered, scale/performance, security, integrations, infrastructure, resilience, testing strategy.

## Guardrails

- **Conversational.** One topic at a time. Ask 1-2 questions, let the user answer, then move on. Steer, don't interrogate.
- **Confirm scope before writing.** Propose which optional sections apply ("This looks like a [simple / standard / enterprise] system; I'd include [sections] and skip [sections]. Sound right?") and get agreement.
- Present the architecture in chat. Write to file only if the user asks.
- Challenge technology choices, flag risks, avoid over-engineering. Every decision must have rationale and acknowledged tradeoffs.
- No code snippets, file names, paths, or version numbers; no over-engineering for hypothetical scale; no hype-driven choices; no optional sections that add nothing.
- Keep the language focused, clean and well-written. Avoid em dash and typical AI style.
