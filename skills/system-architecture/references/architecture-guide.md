# System Architecture Guide

Quality bar for system-scoped architecture.

## Topics

Cover every topic this system needs; omit the rest:

- Components and responsibilities
- Interaction (sequence / data flow)
- Data architecture (what flows, where it lives)
- Dependency direction (policy vs details; core vs plugin)
- Integration type per external touch (in-process, local stand-in, owned remote, third-party)
- Tech stack as plugins (layer / technology / rationale; no version numbers)
- Decisions, tradeoffs, and options left open
- Scope limits

Stack is a detail: name it in the spec; policy still does not know DB, web, or framework. Components scream the domain, not the stack. Data model is architecture; the database product is a mechanism.

## Dependency Rule

Source dependencies point **inward** toward higher-level policy across the whole component graph. Outer pieces (UI, database, web, frameworks) are plugins; inner pieces own the ports. No cycles.

Schematic layers (adapt count; the rule holds): Entities → Use cases → Interface adapters → Frameworks and drivers. Use cases speak request/response, not HTTP or SQL. Flow of control may travel outward. Source dependencies still point in.

## Option preservation

Maximize decisions not made. Leave decoupling mode open (monolith, process, service) until the system forces a choice. A network split is a deployment mode, not a substitute for inward dependencies.

Draw a **seam** when two sides change for different reasons and isolation is worth the cost.

## Integration categories

| Category | Examples | Design move |
| --- | --- | --- |
| In-process | Pure logic, in-memory state | No extra boundary |
| Local stand-in | Postgres → PGLite, filesystem → memory | Test with stand-in; no port unless two real variants |
| Owned remote | Your services, internal APIs | Port owned by policy; adapter for transport |
| Third-party | Stripe, Twilio, SaaS you do not control | Inject at edge; mock in tests |

## Design judgment

Apply every test this system's shape triggers:

- **Deletion test.** Remove the component: complexity vanish (**pass-through**: cut) or scatter (keep)?
- **Seam.** Boundary earns its keep when something varies across it. One implementation: no seam yet.
- **Leakage.** Name concrete leaks of policy into details, or details into policy.
- **Contract = test surface.** State how behavior is verified at the system edge.
- **YAGNI.** Smallest component set that satisfies the vision; no over-engineering for hypothetical scale.

## Output checklist

| Artifact | Include when |
| --- | --- |
| Component overview | Always |
| Dependency sketch | Always |
| Decisions table | Always (decision / rationale / tradeoff) |
| Options not made / scope limits | Always |
| Tech stack | Always (plugins: layer / technology / rationale) |
| Interaction diagram (sequence or flow) | More than three components or multi-party flows |
| Data architecture | Storage exists |
| Contract shapes | APIs, events, or message boundaries between components |
| Integrations | External systems or multiple services |
| Infrastructure and deployment | Something actually ships |
| Alternatives considered | Major tech choices had real alternatives |
| Multi-tenancy model | SaaS or multi-tenant deployments |
| Security and compliance | Auth complexity or sensitive data |
| Scalability and performance | High-load or perf requirements |
| Offline resilience | Must work without connectivity |
| Observability | Production monitoring needed |
| Testing strategy | Complex test requirements |
| Future considerations | Known evolution paths |
| Version history | Writing a file |
