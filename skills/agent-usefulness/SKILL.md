---
name: agent-usefulness
description: Audits a target document or folder of related prose for agent signal-to-noise, cross-file duplication, and safe cuts. Use when the user says /agent-usefulness, agent usefulness, doc noise, or wants prose trimmed for LLM context without losing interpretation or clarity.
disable-model-invocation: true
metadata:
  author: zs
  version: "1.2"
---

# Agent usefulness

## Outcome

**Target:** path, paste, thread anchor, or **folder** of related prose (e.g. skill tree, ADR set, rule pack).

In scope: markdown, specs, ADRs, runbooks, skills, rules. Skip source code, execution-first configs, and generated blobs unless the user includes them.

**Folder scope:** all prose under the path (default: whole tree). Honour user includes/excludes (globs, file list, `only SKILL.md`). Skill or docs folders: default `SKILL.md` plus linked `references/` unless narrowed.

**Neighbourhood:** docs that hold facts the target might duplicate. On folder targets, other in-scope files count as neighbourhood; read outward per [references/audit-workflow.md](references/audit-workflow.md).

**Done when:**

1. **Report** — signal band, noise inventory, neighbourhood overlap, prioritized cuts ([cut format](references/audit-workflow.md)); each cut tagged for agent impact: none, clarity only, interpretation, or action.
   - **Single file:** one report (shape below).
   - **Folder:** one pass per in-scope file, then **folder synthesis** (cross-file dupes, conflicts, authoritative homes, optional verdict rollup).
2. **Verdict** — Ready / Trimmable / Fragmented; per file on folder targets.
3. **Optional apply** — only if asked; every kept fact still in target or neighbourhood. Folder: edit only scoped files.

Default: **audit only**. No edits unless the user asks apply, rewrite, or tighten from this audit.

## Guardrails

- Do not drop anything that changes what an agent would do, infer, or disambiguate: decisions, constraints, exceptions, definitions, numbers, names, links, prerequisites, and "when not to" rules.
- Cut noise, not signal. If unsure, keep or mark **review**. Audit-only: do not delete.
- Fact lives in neighbourhood → cut or one-line pointer in target. Two homes only if audiences differ; say so in the report.
- Folder apply: one authoritative home in the target set; name keeper vs pointer target.
- Target vs neighbourhood conflict → **Risks**; no silent harmonize on audit-only.
- No tighten, unslop, style-gdocs, or caveman-compress unless loaded or chained after this audit.
- Report prose: focused, clean; no em dashes or AI filler.

## Tools

- Read [references/audit-workflow.md](references/audit-workflow.md) first (signal vs noise, neighbourhood, cuts, verdicts, folder workflow).
- **Single file:** full target read; neighbourhood until duplicates stop surfacing.
- **Folder:** list in-scope files; per file full read + neighbourhood (siblings + outward). Do not merge into one blob before audit.
- Write only when the user requested apply.

## Report shape

### Single file

| Section | Content |
| ------- | ------- |
| Snapshot | Path, doc role, neighbourhood files consulted |
| Signal estimate | Rough % signal vs noise (a band, not a false exact number) |
| Keep | Bullets: what must stay and why an agent needs it |
| Cut / merge | Prioritized CUT-N entries; neighbourhood source when duplicate |
| Risks | Blind-cut breakage; target vs neighbourhood conflicts |
| Verdict | Ready / Trimmable / Fragmented |

### Folder

Per file: single-file table under `### path/to/file.md`.

**Folder synthesis** (after all passes):

| Section | Content |
| ------- | ------- |
| Snapshot | Folder path, in-scope file list, shared neighbourhood consulted |
| Cross-target | Dupes and conflicts between in-scope files; authoritative homes |
| Rollup | Optional signal band or per-file verdict table |
| Folder verdict | Ready / Trimmable / Fragmented when structure spans files |

Interactive fixes: walk **Cut / merge** one item at a time (Apply cut / Keep / Defer to neighbourhood edit). Folder targets: each CUT-N names its file.
