# Testing & Validation Strategy

## Core Distinction

- **Testing** — code exercised in-process, no running server, no network. Gates the build.
- **Validation** — scenarios exercised against running components/systems over real interfaces (HTTP, gRPC, message bus). Gates the release.

The boundary is whether the component under verification is running as a deployed process.

## Two Pyramids

Every system is verified through two stacked pyramids. The component pyramid runs first (per-service, in CI). The system pyramid runs second (against the composed stack).

```
SYSTEM PYRAMID (composed stack, post-deployment)
         /    Human QA     \          manual judgment, UX review
        /  Orchestration    \         env manipulation (wipe, stop/start, recovery)
       /   E2E (browser)     \        UI journeys via Playwright
      / System Integration     \      chained API calls, cross-service side-effects
     /  API Regression           \    single request/assert, declarative

════════════════════════════════════════════════════════
           RUNNING BOUNDARY
════════════════════════════════════════════════════════

COMPONENT PYRAMID (per-service, pre-build)
      / Contract Tests  \       interface conformance (Pact, schema validation)
     /  Integration       \     multiple classes, real infra (testcontainers), in-process
    /   Unit                \   single class/function, mocked dependencies
```

## Component Pyramid

Runs in the service's own test suite (`dotnet test`, `npm test`, `go test`). No containers need to be running. Owned by the team that builds the service.

### Unit Tests

Verify a single class or function in isolation. Dependencies are mocked or stubbed.

- **Scope**: one class, one function, one behavior
- **Infrastructure**: none
- **Speed**: milliseconds
- **Example (.NET)**: test that a `PricingCalculator` applies a discount correctly with a mocked `IProductRepository`

### Integration Tests

Verify multiple classes working together with real infrastructure where practical. The component is loaded in-process (e.g., via `WebApplicationFactory` in .NET) — the server is not running as a separate process.

- **Scope**: multiple classes, DI wiring, middleware pipeline, database access
- **Infrastructure**: real database via testcontainers, in-memory providers, or embedded stores
- **Speed**: seconds
- **Example (.NET)**: `WebApplicationFactory` boots the API in-process, a test sends an HTTP request through the full middleware pipeline, and asserts the response and database state

### Contract Tests

Verify that a service's interface conforms to a shared contract. Catches breaking changes between producer and consumer before deployment.

- **Scope**: API surface — request/response shapes, status codes, message schemas
- **Infrastructure**: none (schema validation) or lightweight mock server (Pact)
- **Speed**: milliseconds to seconds
- **Example**: validate that the OpenAPI spec matches the actual controller routes and response DTOs
- **Note**: optional tier — useful in multi-service systems, less relevant for monoliths

### Component Pyramid Decision Tree

```
Is it testing a single class with no real dependencies?
  → Unit test

Does it need real infrastructure (DB, message broker) or exercises
the DI/middleware pipeline, but the process is not deployed?
  → Integration test

Does it verify interface conformance against a shared contract/schema?
  → Contract test
```

## System Pyramid

Runs against the fully composed system (e.g., a `docker compose` stack). Components are running as deployed processes, communicating over real network interfaces. Owned by whoever owns the composed system.

### API Regression

Single request with a single assertion. Declarative, fast, cheap — the bulk of system-level scenarios.

- **Tag**: **(R)**
- **Scope**: one endpoint, one expected outcome
- **Executor**: YAML runner (declarative test definitions)
- **Example**: `POST /api/orders` with a valid payload returns `201` and the response contains an `orderId`

### System Integration

Multi-step API sequences where step N depends on step N-1, or where the assertion verifies a side-effect in another service. Still API-only, no browser.

- **Tag**: **(SI)**
- **Scope**: cross-service workflows, data flow verification, eventual consistency checks
- **Executor**: YAML runner (workflow type) or dedicated test scripts
- **Example**: create a user via the auth service, then verify the user appears in the profile service's database

### E2E (Browser)

User journeys through the UI. Only applicable when there is a frontend.

- **Tag**: **(E)**
- **Scope**: full user workflows through the browser
- **Executor**: Playwright
- **Example**: log in, navigate to dashboard, create a record, verify it appears in the list

### Orchestration

Destructive or environment-altering scenarios. Verifies system resilience, recovery, and provisioning flows.

- **Tag**: **(O)**
- **Scope**: environment manipulation + post-condition assertions
- **Executor**: shell scripts or extended runner with a sequence type
- **Example**: `docker compose down -v && docker compose up -d`, wait for healthy, verify data was re-seeded correctly

### Human QA

Genuinely cannot be automated. Should be rare.

- **Tag**: **(H)**
- **Scope**: CI pipeline triggers, devcontainer lifecycle, visual UX review, judgment calls
- **Executor**: manual
- **Example**: verify that the devcontainer opens cleanly in VS Code and all extensions load

### System Pyramid Decision Tree

```
Is it a single request with a single assertion?
  → (R) Regression

Does it require multiple steps, or verify side-effects across services?
  → (SI) System Integration

Does it require a browser?
  → (E) E2E

Does it manipulate the environment (stop/start, wipe, rebuild)?
  → (O) Orchestration

Can it only be verified by a human?
  → (H) Human QA
```

## Tier Tags Summary

| Tag      | Tier               | Pyramid   | Executor                               |
| -------- | ------------------ | --------- | -------------------------------------- |
| —        | Unit               | Component | `dotnet test` / `npm test` / `go test` |
| —        | Integration        | Component | Same test runner, with testcontainers  |
| —        | Contract           | Component | Schema validator / Pact                |
| **(R)**  | Regression         | System    | YAML runner                            |
| **(SI)** | System Integration | System    | YAML runner (workflow) or test script  |
| **(E)**  | E2E                | System    | Playwright                             |
| **(O)**  | Orchestration      | System    | Shell script or extended runner        |
| **(H)**  | Human QA           | System    | Manual                                 |

## Ownership & Execution

| Pyramid   | Runs when                          | Gates                   | Owner                |
| --------- | ---------------------------------- | ----------------------- | -------------------- |
| Component | CI build, pre-merge                | Build / container image | Service team         |
| System    | Post-deployment to integration env | Release / promotion     | System/platform team |

## Principles

1. **Every exit criterion must be covered.** Each scenario derived from exit criteria lands in exactly one tier.
2. **Push down, not up.** If a scenario can be verified at a lower tier, it belongs there. Don't use system integration to test what a unit test can catch.
3. **The running boundary is real.** Below it: fast, cheap, developer-owned. Above it: slower, more expensive, but verifies what tests cannot — real deployment, real networking, real configuration.
4. **Component tests gate the build. System validations gate the release.** A service that fails its own test suite should never be deployed into the integration environment.
5. **Automate by default, manual by exception.** Every **(H)** scenario should be reviewed periodically: can it be moved to (O) or (E)?
