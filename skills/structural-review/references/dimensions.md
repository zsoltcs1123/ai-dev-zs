# Structural review dimensions

Evaluate the change set on all six dimensions. No written standard → sound structural judgment.

## Authority on conflict

Written standard vs sound judgment → flag **Medium**. Good practice in code is not wrong. Do not change code to match a harmful standard unless the user confirms.

Prefer **principles**, then **conventions**, then general judgment.

## Discovery

| Purpose        | Sources                                                                                           |
| -------------- | ------------------------------------------------------------------------------------------------- |
| Conventions    | `CONTRIBUTING.md`, `DEVELOPING.md`, `AGENTS.md`, `**/conventions.md`, docs next to changed stacks |
| Principles     | `PRINCIPLES.md` or equivalent                                                                     |
| Layering hints | `ARCHITECTURE.md`, ADRs, package READMEs, bounded-context docs when present                       |

Open one or two sibling modules at the same tree level as changed paths. Judge consistency with neighbors, not whole-repo perfection.

No convention or principles docs → say so once in the report; use neighbors and judgment.

## Review scope and reading scope

Resolve scope in this order: user-named paths; user-named branch vs default branch; working tree (staged, unstaged, or both); `git diff <default>...HEAD` when the branch diverged. If none apply, ask what to review. Default branch: `origin/HEAD`, then `main`, then `master`.

You may read outside the diff for layout, naming, and dependencies. Flag only in scope, except **Major** pre-existing hazards the change worsens or extends.

## Severity

- **Major:** Misleading boundaries or layers. Misleading module-boundary names. Catch-all modules added or grown. Cycles or layer crossings that break documented layering.
- **Medium:** Convention or SRP violation. Coupling or weak cohesion. Neighbor inconsistency. Wrong abstraction level.
- **Minor:** Small naming or placement wins; optional splits or renames.

| Severity | Example                                                              |
| -------- | -------------------------------------------------------------------- |
| Major    | Domain logic in `ui/components` while the feature lives in `domain/` |
| Major    | `helpers2.ts` exporting fifteen unrelated symbols                    |
| Medium   | Two feature areas in one 800-line file; siblings split by slice      |
| Medium   | Barrel hides infra imports behind `features/`                        |
| Minor    | Variable `data` where siblings use `invoice` and `lineItem`          |

## Dimension 1 — Layout

1. New files in the right slice, layer, or package; not catch-alls without reason
2. Feature vs layer colocation matches siblings
3. Catch-alls (`utils`, `helpers`, `misc`, `common`) growing without structure
4. Tests mirror production layout when the repo does
5. One file mixing orchestration, low-level helpers, unrelated domain
6. Parallel folder trees for the same concept
7. Big file dumps with no organization

## Dimension 2 — Naming

Domain language; names should reveal responsibility.

1. File names match neighbors (`repository`, `use-case`, `schema`); not `stuff.ts` / `manager.go`
2. Precise vocabulary; no generic `Manager`, `Handler`, `Data`, `Utils` unless domain uses them
3. Public names hide implementation (`Cache` not `RedisCache` when siblings use `Cache`)
4. Casing, suffixes, prefixes match the module
5. One concept, one name; flag `User` vs `Account` without documented distinction

## Dimension 3 — Responsibility

SRP at file and primary-type level.

1. Unrelated concerns in one file when neighbors split (API, persistence, formatting)
2. Code belongs in a sibling module but sits elsewhere
3. Merge: one concept across many tiny files without boundary reason
4. Split: distinct sub-domains or phases in one file
5. Orchestration mixed with low-level detail when repo separates them

## Dimension 4 — Dependencies

Inward direction, layers, acyclic.

1. Domain does not depend on UI/infra unless allowed
2. Cycles or near-cycles introduced or tightened
3. Feature imports another feature's internals, not shared contracts
4. Deep `../../../` where neighbors use aliases or module boundaries
5. `utils` / `helpers` importing features they support
6. Imports break documented layer rules

## Dimension 5 — Surface and abstraction

1. Broad exports vs narrow neighbor facades
2. Layer-crossing types without mapping (infra DTOs in domain signatures)
3. Wrappers with no vocabulary or invariant
4. Duplicated structure neighbors already extract
5. Premature abstraction (single impl interface, unused hooks)
6. Stringly typed boundaries where repo uses types as contracts

## Dimension 6 — Oddities

Unfamiliar, unique, or inconsistent with the touched area.

1. Idioms unused elsewhere in the stack
2. Result/error style vs immediate neighbors
3. One-off frameworks or codegen without peers
4. Misplaced code (rule in config, SQL in UI, test-only prod import)
5. Unusual patterns without comment, ADR, or convention pointer (flag even if unsure)

Intentional oddity → note what doc would justify it; do not invent requirements.
