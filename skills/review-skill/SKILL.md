---
name: review-skill
description: >-
  Reviews Agent Skills (SKILL.md files) for specification conformance, agent
  usability, token efficiency, instruction structure, and scope cohesion. Use
  when the user asks to review, audit, check, or validate a skill they created
  or are editing.
---

# Review Skill

Review a target skill across five dimensions, classify issues by severity, and walk the user through fixes interactively.

## Review Dimensions

### 1. Spec Conformance

Validate against [references/spec-checklist.md](references/spec-checklist.md). Flag every failing item as an issue.

### 2. Agent Usability

- Ambiguous or undefined terms an agent could misinterpret
- Conflicting instructions
- Missing context at decision points ("choose" without criteria)
- Undefined jargon or acronyms
- Assumptions about external state not mentioned in the skill

### 3. Brevity and Token Efficiency

Optimize for maximum meaning in minimum tokens. Every word must justify its presence.

Flag:

- Wordy or roundabout phrasing that could be tighter
- Explanations of things an LLM already knows
- Redundancy (same point stated twice in different words)
- Unnecessary hedging, qualifiers, or filler
- Information duplicated between SKILL.md and reference files
- Content that should move to a reference file to reduce always-loaded tokens
- Lack of focus: sentences or sections that don't directly serve the skill's purpose

### 4. Instruction Sequencing and Structure

- Steps referencing concepts not yet introduced
- Prerequisites mentioned after the step that needs them
- Orphan references (mentioned but never defined)
- Heading hierarchy violations
- Poor progressive disclosure (too much detail upfront, or critical info buried)

### 5. Scope and Cohesion

- Multiple distinct, unrelated workflows in one skill
- Description needing many unrelated trigger terms
- Sections sharing little context with each other
- Skill that should be split into focused, independently-triggerable skills

When flagging scope issues, propose a concrete split (names + which sections go where).

## Severity Definitions

**Major** — Could cause agent drift, hallucination, or wrong behavior. Spec violations that prevent loading/triggering. Scope violations where unrelated workflows will be conflated.

**Medium** — Functional but suboptimal. Occasional confusion, trimmable token waste, structural friction. Scope issues where a split would help but current form is workable.

**Minor** — Cosmetic: typos, formatting, trivial style nits.

## Workflow

1. Read the target skill's directory: SKILL.md + any files in `references/`, `scripts/`, `assets/`.
2. Read this skill's [references/spec-checklist.md](references/spec-checklist.md).
3. Analyze across all five dimensions. Classify each finding by severity.
4. Present summary:

| Dimension              | Major | Medium | Minor |
| ---------------------- | ----- | ------ | ----- |
| Spec conformance       |       |        |       |
| Agent usability        |       |        |       |
| Brevity & token eff.   |       |        |       |
| Sequencing & structure |       |        |       |
| Scope & cohesion       |       |        |       |
| **Total**              |       |        |       |

5. Walk through issues using the format and protocol below.

## Issue Format

Number issues sequentially per severity: MAJOR-1, MAJOR-2, ..., MEDIUM-1, ..., MINOR-1, ...

Present each issue as a series of bold-labeled fields separated by blank lines for readability. Describe proposed fixes in plain prose — no code blocks, raw markdown, or replacement text.

**[SEVERITY-N] Dimension**

**Location:** (section, line range, or element)

**Issue:** (what is wrong)

**Risk:** (what can go wrong if unfixed)

**Proposed fix:** (what to change and how)

→ Fix / Skip / Modify?

## Interaction Protocol

**Major**: one at a time. Present issue, wait for response (Fix / Skip / Modify), then next.

**Medium**: same one-at-a-time flow.

**Minor**: list all at once. Ask: "Fix all, pick specific ones, or skip?"

**Verdict** (after all issues addressed): Pass (no major/medium remain), Pass with caveats (no major; some medium skipped), Needs rework (major issues remain).

## Edge Cases

- **No references/scripts**: skip file-reference checks.
- **Missing/empty frontmatter**: flag as single critical issue, stop review.
- **Very short skill (<20 lines)**: brevity is fine if complete; still check all dimensions.
- **Skill under active editing**: user may say "ignore X for now." Respect and exclude from verdict.
