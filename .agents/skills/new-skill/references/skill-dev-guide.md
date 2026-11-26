# Appendix: Skill Development Guide

## Principles

The guiding principle of skill development is **less is more**.

This is driven by a simple observation: as model capability advances, the need for strict step-by-step procedural instructions keeps shrinking. Given the right outcome, the right tools, and the right guardrails, a capable model will figure out the path to completion on its own, and will often find a better path than the one we would have scripted. Over-specified, procedural skills age badly; they fight the model instead of directing it.

So a good skill gives the agent four things, and little else:

1. **Outcome specification** — the goal and its success criteria, _not_ a procedure. Describe what "done" looks like, then get out of the way.
2. **Constraints / guardrails** — the invariants that must hold regardless of how the model reaches the goal.
3. **Tools** — what the model may use, leaving _when_ and _how_ to the model.
4. **Coordination pattern** — only if the skill is multi-agent by design: how the agents divide and hand off work.

## Format

The skills must adhere to the format specified by [agentskills.io](https://agentskills.io/specification)
