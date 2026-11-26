# Change Architecture Guide

Quality bar for change-scoped system architecture.

## Topics

Cover every topic this change touches; omit the rest:

- Components and responsibilities
- Interaction (sequence / data flow)
- API or message contracts
- Schema or storage changes
- Dependency direction (policy vs details; core vs plugin)
- Integration type per external touch (in-process, local stand-in, owned remote, third-party)
- Decisions and tradeoffs
- Scope limits

## Dependency Rule

Source dependencies point **inward** toward higher-level policy along this change's edges. Outer pieces (UI, database, web, frameworks) are plugins; inner pieces own the ports.

Schematic layers (adapt count; the rule holds): Entities → Use cases → Interface adapters → Frameworks and drivers. Use cases speak request/response, not HTTP or SQL. Flow of control may travel outward. Source dependencies still point in.

## Option preservation

Maximize decisions not made. Policy must not know the database, web, or framework even when the stack is already chosen. A network split is a deployment mode, not a substitute for inward dependencies.

Draw a **seam** when two sides change for different reasons and isolation is worth the cost.

## Integration categories

| Category | Examples | Design move |
| --- | --- | --- |
| In-process | Pure logic, in-memory state | No extra boundary |
| Local stand-in | Postgres → PGLite, filesystem → memory | Test with stand-in; no port unless two real variants |
| Owned remote | Your services, internal APIs | Port owned by policy; adapter for transport |
| Third-party | Stripe, Twilio, SaaS you do not control | Inject at edge; mock in tests |

## Design judgment

Apply every test this change's shape triggers:

- **Deletion test.** Remove the component: complexity vanish (**pass-through**: cut) or scatter (keep)?
- **Seam.** Boundary earns its keep when something varies across it. One implementation: no seam yet.
- **Leakage.** Name concrete leaks of policy into details, or details into policy.
- **Contract = test surface.** State how behavior is verified at the system edge.
- **YAGNI.** Smallest component set that satisfies this change's deliverables.

## Output checklist

| Artifact | Include when |
| --- | --- |
| Component overview | Always |
| Dependency sketch | Always |
| Decisions table | Always (decision / rationale / tradeoff) |
| Scope limits | Always |
| Interaction diagram (sequence or flow) | Multi-step or multi-party flows |
| Contract shapes | APIs, events, or message boundaries change |
| Data model changes | Storage or schema changes |
