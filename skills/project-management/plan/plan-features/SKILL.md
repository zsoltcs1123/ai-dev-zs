---
name: plan-features
description: Decomposes VISION + ARCHITECTURE into workstreams and features. Use when the user says "plan features", "break this into features", "identify workstreams", or wants to go from vision/architecture to a feature inventory.
metadata:
  author: zs
  version: "1.0"
---

# Plan Features

Decompose a project's VISION and ARCHITECTURE into workstreams and features — producing the complete feature inventory that feeds into `plan-feature` (for full specs) and `plan-workstream-roadmap` (for sequencing).

This is a **high-abstraction** document. Features here are identified and scoped, not fully specified. Each entry is a code + name + one-line goal — enough to hand off to `plan-feature` for the full spec.

## Input

Strict — requires structured input:

- **Required:** VISION (or equivalent structured project description).
- **Required:** ARCHITECTURE (components, interactions, technology choices).

If either is missing, push back: "I need both VISION and ARCHITECTURE to decompose into features. Consider running `plan-vision` / `plan-architecture` first."

Freeform context (conversation, notes, constraints) is welcome alongside the two required docs.

## Mode

**Generative.** Upstream docs contain the needed context. Read inputs, produce output, present it. Do not start a conversation. Only ask if the inputs are genuinely ambiguous or contradictory — resolve the specific issue, then generate.

## Procedure

1. **Read the inputs.** Understand scope from VISION and component structure from ARCHITECTURE. Identify natural boundaries.
2. **Identify workstreams.** Determine workstreams as vertical slices of the project — each with a short uppercase code (e.g., `PLT`, `IDX`, `API`). A single workstream is perfectly fine if the project doesn't need more.
3. **Decompose into features.** For each workstream, identify features. Each feature gets a code (`{WS}-{N}`) and a one-line goal. Features should be right-sized per the quality standards in the reference.
4. **Present the feature map.** Follow [references/plan-features.md](references/plan-features.md). Present in chat. The user may reorder, merge, split, rename, reassign across workstreams, or adjust boundaries. Write to file only if the user asks.

Don't force multi-workstream structure where it doesn't add value. A single-workstream project with one code and a flat feature list is completely valid.

### Updating an existing feature map

1. **Read the current feature map fully.**
2. **Clarify what changed and why.** Common scenarios:
   - **New feature identified** — assign code, place in workstream
   - **Feature removed or merged** — update codes and workstream totals
   - **Workstream restructured** — reassign features, update codes
   - **Scope refined** — split or merge features based on new understanding
3. **Apply changes** while maintaining structure and code consistency.

## Stance

Challenge features that are too large (multiple distinct deliverable groups — should split) or too small (a single task dressed up as a feature). Push back on overlapping features. Validate that workstream boundaries align with architectural component boundaries.

**Avoid:**

- Code snippets, file names, directory paths, version numbers
- Detailed deliverables or exit criteria (that's `plan-feature`'s job)
- Milestone sequencing (that's `plan-workstream-roadmap`'s job)
- Goals that describe implementation rather than outcomes
