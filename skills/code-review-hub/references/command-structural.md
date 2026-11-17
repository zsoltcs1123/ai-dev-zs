# Command: structural

Six-dimension organizational review for the Target brief. Report only. Do not edit code.

## Guardrails

- Evaluate all six dimensions below.
- Do not flag pre-existing issues outside the diff unless they are Major and the change makes them worse.
- Correctness, security, performance, tests, and spec conformance are out of scope. Mention briefly if you spot them. Do not expand into that review.
- Skip cosmetic naming unless it is ambiguous or inconsistent with siblings.
- Structural fixes must not change behavior without user confirmation.

## Authority on conflict

Written standard versus sound judgment → flag **Medium**. Good practice in code is not wrong.

Prefer **principles**, then **conventions**, then general judgment.

## Discovery

| Purpose        | Sources                                                                                           |
| -------------- | ------------------------------------------------------------------------------------------------- |
| Conventions    | `CONTRIBUTING.md`, `DEVELOPING.md`, `AGENTS.md`, `**/conventions.md`, docs next to changed stacks |
| Principles     | `PRINCIPLES.md` or equivalent                                                                     |
| Layering hints | `ARCHITECTURE.md`, ADRs, package READMEs, bounded-context docs when present                       |

Open one or two sibling modules at the same tree level as changed paths. Judge consistency with neighbors, not whole-repo perfection.

No convention or principles docs → say so once in the report. Use neighbors and judgment.

## Reading scope

You may read outside the diff for layout, naming, and dependencies. Flag only in-scope issues, except **Major** pre-existing hazards the change worsens or extends.

## Severity

- **Major:** Misleading boundaries or layers. Misleading module-boundary names. Catch-all modules added or grown. Cycles or layer crossings that break documented layering.
- **Medium:** Convention or SRP violation. Coupling or weak cohesion. Neighbor inconsistency. Wrong abstraction level.
- **Minor:** Small naming or placement wins; optional splits or renames.

## Dimension 1 — Layout

1. New files in the right slice, layer, or package; not catch-alls without reason
2. Feature versus layer colocation matches siblings
3. Catch-alls (`utils`, `helpers`, `misc`, `common`) growing without structure
4. Tests mirror production layout when the repo does
5. One file mixing orchestration, low-level helpers, unrelated domain
6. Parallel folder trees for the same concept
7. Big file dumps with no organization

## Dimension 2 — Naming

Domain language. Names should reveal responsibility.

1. File names match neighbors; not `stuff.ts` or `manager.go`
2. Precise vocabulary; no generic `Manager`, `Handler`, `Data`, `Utils` unless the domain uses them
3. Public names hide implementation when siblings do
4. Casing, suffixes, prefixes match the module
5. One concept, one name; flag `User` versus `Account` without documented distinction

## Dimension 3 — Responsibility

SRP at file and primary-type level.

1. Unrelated concerns in one file when neighbors split concerns
2. Code belongs in a sibling module but sits elsewhere
3. Merge: one concept across many tiny files without boundary reason
4. Split: distinct sub-domains or phases in one file
5. Orchestration mixed with low-level detail when the repo separates them

## Dimension 4 — Dependencies

Inward direction, layers, acyclic.

1. Domain does not depend on UI or infra unless allowed
2. Cycles or near-cycles introduced or tightened
3. Feature imports another feature's internals, not shared contracts
4. Deep `../../../` where neighbors use aliases or module boundaries
5. `utils` or `helpers` importing features they support
6. Imports break documented layer rules

## Dimension 5 — Surface and abstraction

1. Broad exports versus narrow neighbor facades
2. Layer-crossing types without mapping
3. Wrappers with no vocabulary or invariant
4. Duplicated structure neighbors already extract
5. Premature abstraction
6. Stringly typed boundaries where the repo uses types as contracts

## Dimension 6 — Oddities

Unfamiliar or inconsistent patterns in the touched area.

1. Idioms unused elsewhere in the stack
2. Result or error style versus immediate neighbors
3. One-off frameworks or codegen without peers
4. Misplaced code (rule in config, SQL in UI, test-only prod import)
5. Unusual patterns without comment, ADR, or convention pointer (flag even if unsure)

Intentional oddity → note what doc would justify it. Do not invent requirements.

## Report

Three sections before you return to the coordinator:

1. **Summary.** One to three sentences: where code lives, how modules grew. No problems.
2. **Findings by dimension.** One line each under Layout, Naming, Responsibility, Dependencies, Surface and abstraction, Oddities. Empty dimension → `none`.
3. **Totals.** `Major N · Medium N · Minor N`.

One clause per finding.

Return these headings:

- `## Summary`, `## Findings` (lines: `severity | category | file:line | clause`), `## Totals`, `## Skipped`

Set `category` to the dimension name.