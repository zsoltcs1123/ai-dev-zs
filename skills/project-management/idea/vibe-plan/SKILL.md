---
name: vibe-plan
description: Refines an idea into a high-level vibe plan through guided conversational exploration. Use when the user wants to explore a project idea, says "vibe plan this", "let's explore this idea", or wants to think through feasibility, scope, and tech choices before committing to a spec.
metadata:
  author: zs
  version: "1.0"
---

# Vibe Plan

Explore a project idea through conversation and produce a high-level vibe plan.

## When to Use

- User has an idea (raw or captured via `capture-idea` skill) and wants to explore it
- User wants to think through feasibility, scope, or tech choices before specifying
- User explicitly asks for a vibe plan

## Input

Freeform text or an idea file — anything from a few keywords to a structured idea capture.

## Conversation Style

Focus on one topic at a time. Ask 1-2 questions, let the user answer, then move on. Don't dump a wall of questions. Let the conversation flow naturally; tangents are fine. You're steering, not interrogating.

## Procedure

1. **Start from the idea.** Read the input, understand the core intent.
2. **Explore through conversation.** Cover relevant topics — not all apply to every idea, use judgment:
   - Required details to start thinking about the project
   - Feasibility
   - Technological choices
   - Technical design
   - Alternatives, options, tradeoffs
   - Scope tiers — what defines a POC, MVP, V1 for this project?
   - Data design / data flow
   - Monetization / business model (when commercial)
   - Deployment / distribution
   - Third-party integrations / external dependencies
   - Limitations, constraints, risks
   - Existing alternatives / prior art
3. **Produce the plan.** Either the user says they're ready, or you propose that enough ground is covered. User confirms before you write.
4. **Present in chat.** Follow the template below as a loose skeleton. If the user asks, write to a file.

## Vibe Plan Template

Deviate when the project calls for it — not every section applies.

- **Project overview** — one-paragraph summary of what this is and why it exists
- **Target users / audience**
- **Core features** — broken into tiers (POC / MVP / V1) where applicable
- **Tech considerations** — stack ideas, key libraries, infrastructure
- **Data design** — high-level data model or data flow
- **Suggested workstreams** — optional; only when the idea is large enough to have parallel development tracks (e.g. "Platform", "API", "Frontend"). Omit for single-track projects.
- **Risks and open questions**
- **Existing alternatives / prior art**

## Scope

A vibe plan is NOT a specification. Keep it high level. Max ~250-300 lines. Don't get into implementation details, task breakdowns, or architecture decisions — those belong in downstream skills.

## Stance

- **Scope control** — stop the user from overengineering or feature-creeping
- **Feasibility checks** — call out when something is unrealistic for a solo dev
- **Alternatives** — suggest options the user might not have considered
- **Honest pushback** — challenge rather than agree
