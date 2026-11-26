# Program Design Guide

Quality bar for change-scoped program design.

## Topics

Cover every topic this change touches; omit the rest:

- Seams and adapters (ports inner policy owns)
- Key types and function/method signatures
- Call flow for changed behavior
- File layout changes
- Import-level dependency direction
- Vertical slice plan (end-to-end, not layer-by-layer)

## Dependency Rule

Inner policy does not name outer framework, transport, or storage types. Data crosses boundaries as simple structures (DTOs), not entities or database rows. Humble objects on the outer side: views, gateways, mappers, listeners. `Main` and outer plugins hold framework coupling swept to the edge.

If every type is public, folder layout is cosmetic. Prefer access boundaries the compiler can enforce.

## Vertical slices

Each use case is a thin slice through horizontal layers. Order by slice, not by layer (all migrations, then all services, then all UI).

- Each slice shippable and testable end-to-end (entry point → behavior → persistence as applicable).
- Prefer 1–3 slices.
- After each slice, something observable works (curl, browser, test, or equivalent).

## Design judgment

Apply every test this change's shape triggers:

- **Deletion test.** Remove the file or module: complexity vanish (**pass-through**: cut) or scatter (keep)?
- **Small surface, hidden complexity.** Few entry points; most logic behind them.
- **Seam.** Abstraction only when two real variants exist.
- **Locality.** One use case should not hop through many thin files.
- **Test through the surface.** Signatures and public boundaries define how slices get verified.

## Partial boundaries

Strategy, Facade, or same-deployable placeholders are acceptable when full isolation is too costly. Name what would trigger completing the boundary.

## Output checklist

| Artifact | Include when |
| --- | --- |
| Call-stack tree | Always (diff syntax when modifying existing flow) |
| File-tree diff | Always |
| Types and signatures | Always (key interfaces only, no bodies) |
| Dependency check | Always (inner code does not name outer types) |
| Slice strategy | Always (ordered vertical slices) |
