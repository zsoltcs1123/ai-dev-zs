---
name: plan-architecture
description: Produces the architecture document for a project. Use when the user says "plan architecture", "design the architecture", or wants to define technical structure, components, and technology choices.
metadata:
  author: zs
  version: "1.0"
---

# Plan Architecture

Guide the user through defining high-level technical structure, components, and technology choices. Produce an ARCHITECTURE.md.

This is a **high-abstraction** document. It describes _what_ the system is made of and _why_ — not _how_ it's coded. Never include code examples, file names, directory paths, or specific version numbers. Those belong in implementation specs and task plans.

Architecture is a living document that can evolve with the project, but changes should be controlled and deliberate. A good architecture rarely needs changing — that's a sign of solid upfront scoping.

## Input

Requires a well-defined vision — a VISION.md or equivalent document with clear problem statement, scope, and constraints.

If the input is vague or insufficient, push back. Softly redirect: "The vision isn't clear enough to make architecture decisions yet. Let's nail that down first — consider using `plan-vision`."

## Mode

**Conversational.** This skill explores decisions through guided dialogue. Focus on one topic at a time. Ask 1-2 questions, let the user answer, then move on. Steer, don't interrogate.

## Procedure

1. **Read the vision.** Understand scope, constraints, and requirements.
2. **Explore through conversation.** Cover the key questions — not all apply:
   - What are the main components? How do they interact?
   - What flows through the system? Where is data stored?
   - What technologies? Why?
   - For larger projects: alternatives considered, scale/performance, security, integrations, infrastructure, resilience, testing strategy
3. **Propose document scope.** "This looks like a [simple / standard / enterprise] system. I'd include [sections] and skip [sections]. Sound right?"
4. **Produce the architecture.** Present in chat. Write to file only if the user asks.

## Output

Follow [references/plan-architecture.md](references/plan-architecture.md) for the section reference and quality standards.

Scale the document to the project. A simple project needs 1-2 pages. An enterprise system may need 10+. Only include sections that add value.

## Stance

Challenge technology choices. Flag risks. Avoid over-engineering. Every decision must have rationale and tradeoffs acknowledged.
