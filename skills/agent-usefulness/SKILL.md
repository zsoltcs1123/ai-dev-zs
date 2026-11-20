---
name: agent-usefulness
description: Audits a target document (not source code) for agent signal-to-noise, cross-file duplication, and safe cuts. Use when the user says /agent-usefulness, agent usefulness, doc noise, or wants prose trimmed for LLM context without losing interpretation or clarity.
disable-model-invocation: true
metadata:
  author: zs
  version: "1.1"
---

# Agent usefulness

## Outcome

**Target:** one document the user names: a path, a paste, or a clear anchor in the thread. Markdown, specs, ADRs, runbooks, skills, rules, and similar prose. Skip source code, configs whose main job is execution, and generated blobs unless the user includes them.

**Neighbourhood:** nearby docs you read to spot duplication and see where facts already live.

**Done when:**

1. **Report** — signal estimate (band), noise inventory, neighbourhood overlap, and prioritized cuts. Use the cut entry format in [references/audit-workflow.md](references/audit-workflow.md). Tie each cut to agent impact: none, clarity only, interpretation, or action.
2. **Verdict** — Ready (already dense), Trimmable (cuts identified), or Fragmented (split or dedupe across files before local tighten helps).
3. **Optional apply** — only if the user asked to rewrite or apply: edited target where every kept fact still appears in the target or neighbourhood; agent actions and meaning stay as strong.

Default: **audit only**. Do not edit unless the user asks for apply, rewrite, or tighten from this audit.

## Guardrails

- Do not drop anything that changes what an agent would do, infer, or disambiguate: decisions, constraints, exceptions, definitions, numbers, names, links, prerequisites, and "when not to" rules.
- Cut noise, not signal. If unsure, keep the text or mark **review** in the report. On audit-only runs, do not delete.
- When the same fact lives authoritatively in the neighbourhood, cut it or replace it with a one-line pointer in the target. Do not keep two competing homes unless audiences differ and you say so in the report.
- If the target and neighbourhood disagree on a fact, flag the conflict in **Risks**; do not harmonize silently on audit-only runs.
- Do not run tighten, unslop, style-gdocs, or caveman-compress unless the user loaded that skill or asked to chain it after the audit.
- Write the report in focused, clean prose. No em dashes or typical AI filler.

## Tools

- Read [references/audit-workflow.md](references/audit-workflow.md) first: signal vs noise, neighbourhood scope, cut format, verdict rules.
- Read the target in full.
- Read the neighbourhood per that reference; stop when more files no longer reveal duplication.
- Write the target only when the user requested apply.

## Report shape

| Section | Content |
| ------- | ------- |
| Snapshot | Path, doc role, neighbourhood files consulted |
| Signal estimate | Rough % signal vs noise (a band, not a false exact number) |
| Keep | Bullets: what must stay and why an agent needs it |
| Cut / merge | Prioritized CUT-N entries; neighbourhood source when duplicate |
| Risks | Blind-cut breakage; target vs neighbourhood conflicts |
| Verdict | Ready / Trimmable / Fragmented |

For interactive fixes, walk **Cut / merge** one item at a time: Apply cut / Keep / Defer to neighbourhood edit.