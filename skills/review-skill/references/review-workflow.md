# Review Workflow

## Dimensions

### Spec Conformance

Fetch and validate against [agentskills.io/specification](https://agentskills.io/specification). Flag every failing requirement. Use `skills-ref validate` when available.

### Agent Usability

- Ambiguous or undefined terms an agent could misinterpret
- Conflicting instructions
- Missing context at decision points ("choose" without criteria)
- Undefined jargon or acronyms
- Assumptions about external state not mentioned in the skill

### Brevity and Token Efficiency

Every word must justify its presence. Flag wordy phrasing, explanations of things an LLM already knows, redundancy, hedging/filler, duplication between SKILL.md and references, content that should move to references, and unfocused sections.

### Instruction Sequencing and Structure

- Steps referencing concepts not yet introduced
- Prerequisites mentioned after the step that needs them
- Orphan references
- Heading hierarchy violations
- Poor progressive disclosure

### Scope and Cohesion

- Multiple distinct, unrelated workflows in one skill
- Description needing many unrelated trigger terms
- Sections sharing little context
- Skill that should be split

When flagging scope issues, propose a concrete split (names + which sections go where).

## Summary Table

| Dimension              | Major | Medium | Minor |
| ---------------------- | ----- | ------ | ----- |
| Spec conformance       |       |        |       |
| Agent usability        |       |        |       |
| Brevity & token eff.   |       |        |       |
| Sequencing & structure |       |        |       |
| Scope & cohesion       |       |        |       |
| **Total**              |       |        |       |

## Issue Format

Number sequentially per severity: MAJOR-1, MEDIUM-1, MINOR-1, ...

**[SEVERITY-N] Dimension**

**Location:** section, line range, or element

**Issue:** what is wrong

**Risk:** what can go wrong if unfixed

**Proposed fix:** what to change and how (plain prose — no code blocks)

→ Fix / Skip / Modify?

## Interaction Protocol

**Major / Medium:** one at a time. Present issue, wait for response, then next.

**Minor:** list all at once. Ask: "Fix all, pick specific ones, or skip?"

**Verdict** (after all issues addressed): Pass (no major/medium remain), Pass with caveats (no major; some medium skipped), Needs rework (major issues remain).

## Edge Cases

- **No references/scripts:** skip file-reference checks.
- **Missing/empty frontmatter:** flag as single critical issue, stop review.
- **Very short skill (<20 lines):** brevity is fine if complete; still check all dimensions.
- **Skill under active editing:** user may say "ignore X for now." Respect and exclude from verdict.
