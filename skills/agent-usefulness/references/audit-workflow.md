# Audit workflow

## Agent signal vs noise

**Signal** (keep unless duplicated authoritatively elsewhere):

- Instructions an agent must follow, including order and gates
- Decisions, rationales that change future choices, and explicit non-goals
- Constraints, invariants, exceptions, and failure modes
- Definitions, disambiguation (colliding terms), and scope boundaries
- Identifiers: names, paths, commands, env vars, versions, URLs, numbers with units
- Preconditions, inputs, outputs, and success criteria
- Examples that each teach a **different** edge or pattern

**Noise** (cut or merge when safe):

- Restatement of body in intro, heading, or recap
- Duplicate examples of the same point
- Throat-clearing, hedging, and "as mentioned above"
- Human narrative that does not change agent behavior (history, motivation already in a decision line)
- Generic best practices with no project-specific hook
- Long prose where a list, table, or one constraint line suffices
- Content copied from neighbourhood files without a new angle

**Review** (flag, do not auto-cut):

- Ambiguous whether a paragraph is motivation or a hidden constraint
- Terms used once with no definition and no neighbourhood definition
- Tables or diagrams whose semantics are unclear after removing surrounding prose

## Neighbourhood scope

Read outward until new files stop turning up duplicate facts:

1. **Same directory** — siblings, `_index`, README, AGENTS.md in that tree
2. **Linked graph** — outbound links from the target; inbound via path or title (search when links are missing)
3. **Series** — numbered docs, ADR sequences, skill collections, rule packs sharing a parent
4. **Repo anchors** — root README, AGENTS.md, CLAUDE.md, skills index when the target is part of that ecosystem

**Folder target:** per file, neighbourhood = other in-scope siblings plus items 1–4 from that file's location. Cross-target overlap belongs in **Folder synthesis → Cross-target**, not only per-file pointers.

Record consulted files in **Snapshot**. Note **authoritative home** for each duplicated fact (newest ADR, spec section, skill outcome block, and so on).

## Folder target workflow

1. **Scope** — list in-scope prose paths; honour user includes/excludes.
2. **Passes** — stable order (e.g. sorted paths); one file per pass, full single-file report subsection each time; no merge-into-one-blob.
3. **Per pass** — full read; neighbourhood (siblings + outward); Keep, Cut / merge, Risks, verdict for that file only.
4. **Synthesis** — cross-target dupes/conflicts, optional rollup, folder verdict if structure spans files.
5. **Apply** — file by file; **move** across files only when user asked to apply the folder.

## Duplication handling

| Situation | Action in target |
| --------- | ------------------ |
| Verbatim duplicate in neighbourhood | Cut; optional one-line pointer to authoritative file |
| Partial overlap | Keep only delta; pointer for shared baseline |
| Conflict between target and neighbourhood | Flag in **Risks**; do not silently harmonize on audit-only |
| Same fact, different emphasis for humans vs agents | Keep one agent-first doc; shorten the other to pointer + delta |

## Signal estimate

Use a band, e.g. **70 to 85% signal**, not a single percentage. Base it on the share of lines or blocks in **Keep** vs **Cut / merge**, and on whether fragmentation dominates local cuts.

## Cut entry format

Each proposed cut:

**ID:** CUT-1

**Location:** file path (required for folder targets), then heading or line range

**Kind:** duplicate | restatement | filler | generic | structural

**Neighbourhood:** file that already holds this fact, or — if none

**Agent impact if removed:** none | clarity only | interpretation | action

**Proposed change:** delete | shorten | pointer | move (name destination)

## Verdict rules

- **Ready** — signal band high; cuts minor or none
- **Trimmable** — meaningful noise or duplication in the target; safe local edits exist
- **Fragmented** — large neighbourhood overlap, or doc mixes unrelated workflows; fix structure or authoritative homes before aggressive local cuts

## Apply mode

When the user requests apply:

1. Deliver the report first unless they asked to skip straight to edit
2. Apply **Cut / merge** in priority order; respect **Risks**
3. After write, short **diff summary**: lines removed, pointers added, facts verified against neighbourhood
4. If net removal is small and the doc was already dense, say so; do not churn

## Edge cases

- **Folder target** — skip binary and non-prose unless included; huge trees: sample, state limitation, or ask to narrow scope
- **Pasted text only, no path** — neighbourhood is thread plus anything the user names; say what was not checked
- **Generated or huge files** — sample for patterns; report limitation; do not rewrite entire generated dumps without scope
- **Mixed code blocks in a doc** — treat blocks as signal if they are the spec (commands, APIs); not a "source code" skip
- **Legal / compliance text** — do not cut; mark immovable in **Keep**
