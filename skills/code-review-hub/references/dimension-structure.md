# Dimension: structure

Organizational review for the Target brief. Run all six internal checks in one report.

Read [shared-guardrails.md](shared-guardrails.md) first.

## Guardrails

- Evaluate all six internal checks below.
- Do not flag pre-existing issues outside the diff unless they are **Major** and the change makes them worse.
- Skip cosmetic naming unless it is ambiguous or inconsistent with siblings.
- Do not change behavior with structural fixes unless the user confirms.
- Do not report bugs, security issues, spec gaps, or test gaps. Other dimensions own those topics.

## Authority on conflict

When a written standard conflicts with sound judgment, severity is **Medium**. Good practice in code is not wrong.

Prefer **principles**, then **conventions**, then general judgment. **conformance** owns explicit doc violations. **structure** owns neighbor and layout judgment when docs are silent.

## Discovery

| Purpose | Sources |
| ------- | ------- |
| Conventions | `CONTRIBUTING.md`, `DEVELOPING.md`, `AGENTS.md`, `**/conventions.md`, docs next to changed stacks |
| Principles | `PRINCIPLES.md` or equivalent |
| Layering hints | `ARCHITECTURE.md`, ADRs, package READMEs, bounded-context docs when present |

Open one or two sibling modules at the same tree level as changed paths. Judge consistency with neighbors, not whole-repo perfection.

When convention or principles docs are missing, say so once in **Skipped**. Use neighbors and judgment.

## Reading scope

You may read outside the diff for layout, naming, and dependencies. Flag only in-scope issues, except **Major** pre-existing hazards the change worsens or extends.

## Severity

- **Major:** Misleading boundaries or layers. Misleading module-boundary names. Catch-all modules added or grown. Cycles or layer crossings that break documented layering.
- **Medium:** SRP problems judged structurally (do not duplicate **conformance** doc line items). Coupling or weak cohesion. Neighbor inconsistency. Wrong abstraction level.
- **Minor:** Small naming or placement wins; optional splits or renames.

## Internal checks

### Layout

1. New files belong in the right slice, layer, or package, not catch-alls without reason.
2. Feature versus layer colocation matches siblings.
3. Catch-alls (`utils`, `helpers`, `misc`, `common`) grow without structure.
4. Tests mirror production layout when the repo does.
5. One file mixes orchestration, low-level helpers, and unrelated domain logic.
6. Parallel folder trees exist for the same concept.
7. Large file dumps have no organization.

### Naming

Use domain language. Names should reveal responsibility.

1. File names match neighbors, not `stuff.ts` or `manager.go`.
2. Vocabulary is precise. Avoid generic `Manager`, `Handler`, `Data`, or `Utils` unless the domain uses them.
3. Public names hide implementation when siblings do.
4. Casing, suffixes, and prefixes match the module.
5. One concept, one name. Flag `User` versus `Account` without a documented distinction.

### Responsibility

Apply SRP at file and primary-type level.

1. Unrelated concerns share one file when neighbors split concerns.
2. Code belongs in a sibling module but sits elsewhere.
3. Merge: one concept spread across many tiny files without a boundary reason.
4. Split: distinct sub-domains or phases in one file.
5. Orchestration mixed with low-level detail when the repo separates them.

### Dependencies

Keep inward direction, layers, and acyclic graphs.

1. Domain does not depend on UI or infra unless docs allow it.
2. Cycles or near-cycles are introduced or tightened.
3. A feature imports another feature's internals instead of shared contracts.
4. Deep `../../../` paths where neighbors use aliases or module boundaries.
5. `utils` or `helpers` import the features they support.
6. Imports break documented layer rules.

### Surface and abstraction

1. Exports are broader than narrow neighbor facades.
2. Types cross layers without mapping.
3. Wrappers have no vocabulary or invariant.
4. Structure duplicates what neighbors already extract.
5. Abstraction arrives too early.
6. Boundaries are stringly typed where the repo uses types as contracts.

### Oddities

Unfamiliar or inconsistent patterns in the touched area.

1. Idioms unused elsewhere in the stack.
2. Result or error style differs from immediate neighbors.
3. One-off frameworks or codegen without peers.
4. Misplaced code (rule in config, SQL in UI, test-only prod import).
5. Unusual patterns lack a comment, ADR, or convention pointer (flag even if unsure).

For an intentional oddity, note which doc would justify it. Do not invent requirements.

## Report

1. **Summary.** Where code lives and how modules grew. Do not list problems.
2. **Findings.** Set `category` to `structure: Layout`, `structure: Naming`, and so on.
3. **Totals** and **Skipped** per [shared-guardrails.md](shared-guardrails.md).