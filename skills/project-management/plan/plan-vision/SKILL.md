---
name: plan-vision
description: Produces the vision document for a project through guided conversation. Use when planning a new project, the user says "plan vision", "create a vision", or wants to define the problem, scope, and strategic direction.
metadata:
  author: zs
  version: "1.0"
---

# Plan Vision

Guide the user through defining the core problem, vision, and strategic direction for a project. Produce a VISION.md.

Once established, a vision should rarely change — only when the project itself changes substantially.

## Input

Flexible — freeform text, an idea file, a vibe plan, or anything resembling a project description. The skill should work with whatever is provided, however vague.

If the input has too little substance to start (e.g., a single word with no context), push back gently and ask for more.

## Mode

**Conversational.** This skill explores decisions through guided dialogue. Focus on one topic at a time. Ask 1-2 questions, let the user answer, then move on. Steer, don't interrogate.

## Procedure

1. **Understand the input.** Read what's provided, assess project scale.
2. **Explore through conversation.** Cover the key questions — not all apply to every project:
   - What specific problem are you solving? Who has it?
   - What does success look like?
   - What's in v1? What's out?
   - Time/budget? Technical limits? Team size?
   - For larger projects: business context, users & stakeholders, success metrics, risks
3. **Propose document scope.** "This seems like a [simple tool / standard app / enterprise system]. I'd include [sections]. Sound right?"
4. **Produce the vision.** Present in chat. Write to file only if the user asks.

## Output

Follow [references/plan-vision.md](references/plan-vision.md) for the section reference and quality standards.

Scale the document to the project. A weekend project needs half a page. An enterprise system may need 5+.

## Stance

Challenge vague statements. Validate assumptions. Flag risks early. Push back on scope creep.
