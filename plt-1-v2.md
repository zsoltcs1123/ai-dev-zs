# Task Plan: PLT-1 Infrastructure Spike

## Summary

Stand up all platform infrastructure components (PostgreSQL, ThingsBoard, Keycloak, API Gateway, stub backends, observability) in Docker Compose so they run together, communicate, and are validated — including a Windows Server deployment path assessment.

| #   | Item                                                     | Type       | Depends on    |
| --- | -------------------------------------------------------- | ---------- | ------------- |
| 1   | Define Docker Compose base stack                         | Task       | None          |
| 2   | Add ThingsBoard to Compose stack                         | Task       | 1             |
| 3   | Add Keycloak to Compose stack                            | Task       | 1             |
| V1  | Infrastructure services communicate                      | Validation | 1, 2, 3       |
| 4   | Configure API Gateway                                    | Task       | 2, 3          |
| 5   | Create stub backends with health/ready/metrics endpoints | Task       | 1             |
| V2  | Gateway routes reach backend services                    | Validation | 2, 3, 4, 5    |
| 6   | Add observability stack                                  | Task       | 5             |
| V3  | Observability sees all services                          | Validation | 5, 6          |
| 7   | Configure Compose profiles for local development         | Task       | 5, 6          |
| V4  | Developer workflow (infra-only + local backend)          | Validation | 5, 6, 7       |
| 8   | Validate full stack end-to-end                           | Task       | 4, 5, 6, 7    |
| V5  | Full stack end-to-end                                    | Validation | 4, 5, 6, 7, 8 |
| 9   | Validate Windows Server deployment                       | Task       | 8             |

## Tasks & Validations

### 1. Define Docker Compose base stack

Create the Docker Compose foundation: three PostgreSQL instances (tb-postgres, keycloak-postgres, idx-postgres), a shared internal network, named volumes for persistence, and externalized configuration via `.env.template`.

**Steps:**

1. Create `docker-compose.yml` with three PostgreSQL service definitions using PostgreSQL 18, each with a healthcheck block
2. Define a shared internal Docker network and attach all services
3. Configure named volumes for each database's data directory
4. Create `.env.template` with all database credentials, ports, and version pins
5. Add `.env` to `.gitignore` and document the copy-from-template setup step

**Implementation requirements:**

- Three PostgreSQL service definitions, each with a `healthcheck` block
- All credentials and ports reference `${ENV_VAR}` syntax — no hardcoded secrets in the Compose file
- A shared Docker network is defined and assigned to all services
- Named volumes declared for each database's data directory
- `.env` listed in `.gitignore`
- `.env.template` exists with documented defaults for every variable the Compose file references

**Verification scenarios:**

- `docker compose up -d` with `.env` copied from template — all three Postgres containers reach `healthy` state
- Connect to each database with `psql` using credentials from `.env` — connection succeeds
- Remove named volumes and recreate — databases start clean without errors
- Omit a required env var — Compose fails with a clear error (no silent default)

**Depends on:** None

---

### 2. Add ThingsBoard to Compose stack

Add ThingsBoard CE as a Docker service, bound to its dedicated PostgreSQL instance, with correct environment configuration for database and transport.

**Steps:**

1. Add ThingsBoard CE service using the official `thingsboard/tb-postgres` image
2. Configure TB environment variables for database connection (tb-postgres), MQTT, HTTP, and CoAP transport ports
3. Add a healthcheck hitting TB's HTTP endpoint
4. Set `depends_on` on tb-postgres with `condition: service_healthy`
5. Expose TB's HTTP port and MQTT port (1883)

**Implementation requirements:**

- TB service definition references tb-postgres via environment variables, not hardcoded host/port
- `depends_on` uses `condition: service_healthy` for tb-postgres
- Healthcheck defined against TB's HTTP endpoint
- MQTT port (1883) and HTTP port exposed in the Compose file
- TB service attached to the shared network

**Verification scenarios:**

- Start stack — TB container logs show successful database initialization and "Started ThingsBoard" message
- Hit TB HTTP endpoint — login page HTML returned
- Publish an MQTT message to TB broker — no connection refused error
- TB restarts after tb-postgres restart — TB reconnects without manual intervention

**Depends on:** 1

---

### 3. Add Keycloak to Compose stack

Add Keycloak as a Docker service in development mode, bound to its dedicated PostgreSQL instance.

**Steps:**

1. Add Keycloak service using the official `quay.io/keycloak/keycloak` image with `start-dev` command
2. Configure environment variables for database vendor (postgres), connection URL (keycloak-postgres), admin credentials
3. Add a healthcheck on Keycloak's `/health/ready` endpoint
4. Set `depends_on` on keycloak-postgres with `condition: service_healthy`
5. Expose Keycloak's HTTP port

**Implementation requirements:**

- Keycloak service uses `start-dev` command
- Database connection references keycloak-postgres via environment variables
- Admin credentials sourced from environment variables, not hardcoded
- `depends_on` uses `condition: service_healthy` for keycloak-postgres
- Healthcheck defined against `/health/ready`
- Keycloak service attached to the shared network

**Verification scenarios:**

- Start stack — Keycloak logs show successful database migration and "Listening on" message
- Hit `/health/ready` — returns 200 with status "UP"
- Hit `/realms/master` — returns realm metadata JSON
- Keycloak restarts after keycloak-postgres restart — reconnects without data loss

**Depends on:** 1

---

### V1. Validation: Infrastructure services communicate

**After tasks:** 1, 2, 3

**What to validate:** ThingsBoard and Keycloak each connect to their dedicated PostgreSQL instance on the shared network and initialize successfully.

**Validation scenarios:**

- Start stack, log in to ThingsBoard with default sysadmin credentials — dashboard loads (confirms TB ↔ tb-postgres)- Log in to Keycloak admin console with credentials from `.env` — admin dashboard loads (confirms KC ↔ keycloak-postgres)- Create a test entity in ThingsBoard (e.g., a device) — entity persists after TB restart (confirms data written to tb-postgres)
---

### 4. Configure API Gateway

Evaluate gateway options, select one, configure path-based routing to all backend services, and document the decision. Traefik requires a paid license — prefer an alternative.

**Steps:**

1. Evaluate Caddy, nginx, and HAProxy against requirements: path-based routing, TLS termination, healthcheck routing, WebSocket support (for SignalR/TB), Docker integration
2. Select gateway and document the decision rationale as an ADR
3. Add gateway service to `docker-compose.yml`, expose port 80
4. Configure routing rules: `/` → landing page (placeholder), `/auth/*` → Keycloak, `/idx/*` → IDX backend, `/energy/*` → Energy backend, `/assets/*` → Asset Manager backend (placeholder); ThingsBoard is backend-only, not gateway-routed
5. Configure WebSocket passthrough for future SignalR connections

**Implementation requirements:**

- Gateway service definition exists in `docker-compose.yml` with a healthcheck
- Routing config defines path-based rules for `/auth/*`, `/idx/*`, `/energy/*`, `/assets/*`, and a default `/` route
- No ThingsBoard route exists through the gateway — TB is direct-access only
- ADR document exists in `docs/decisions/` with gateway selection rationale
- Gateway port is configurable via environment variable
- Gateway attached to the shared network

**Verification scenarios:**

- `curl http://localhost/auth/realms/master` — proxied to Keycloak, realm JSON returned with `/auth/` prefix in URLs
- `curl http://localhost/idx/health` — returns 502 (no backend yet), confirming route reaches upstream
- `curl http://localhost/energy/health` — returns 502 (no backend yet), confirming route reaches upstream
- Request to non-existent route `/foo` — returns gateway default page (200)
- `curl http://localhost/health` — returns 200 (gateway health)
- Keycloak OIDC discovery at `http://localhost/auth/realms/master/.well-known/openid-configuration` — all endpoint URLs contain `/auth/` prefix
- Keycloak token endpoint at `POST http://localhost/auth/realms/master/protocol/openid-connect/token` with invalid client — returns Keycloak 400/401 (not gateway 502)
- Keycloak admin login at `http://localhost/auth/admin/` — form submits and redirects correctly
- Stop Keycloak — gateway still starts, returns 502 for `/auth/*`, other routes unaffected
- Restart gateway — comes back healthy, all routes resume without restarting other services
- WebSocket upgrade request to gateway — gateway forwards upgrade headers to upstream
- Change gateway port env var to non-standard value — gateway listens on new port, all routes work
- Gateway config validation command (e.g., `caddy validate`) — exits 0

**Depends on:** 2, 3

---

### 5. Create stub backends with health/ready/metrics endpoints

Create IDX and Energy .NET minimal API backends with liveness, readiness, and Prometheus metrics endpoints following container-readiness standards. Dockerize both and add to the Compose stack.

**Steps:**

1. Create IDX and Energy .NET minimal API projects
2. Add OpenTelemetry Prometheus exporter and ASP.NET health check packages
3. Implement `/health` as a cheap liveness probe (no external calls) on both backends
4. Implement `/ready` on IDX that checks connectivity to idx-postgres; implement `/ready` on Energy as a placeholder that always returns healthy
5. Implement `/metrics` endpoint exposing Prometheus-format metrics via OpenTelemetry on both backends
6. Create multi-stage Dockerfiles for both backends
7. Add both services to `docker-compose.yml` with healthchecks on `/health`; IDX `depends_on` idx-postgres, Energy has no database dependency

**Implementation requirements:**

- Both projects use ASP.NET `AddHealthChecks()` with separate liveness and readiness registrations
- IDX readiness check includes a database connectivity check for idx-postgres
- Energy readiness check is a placeholder with no external dependency
- `/health` endpoint has no external calls (liveness must be cheap per container-readiness standards)
- `/metrics` endpoint uses OpenTelemetry Prometheus exporter
- Multi-stage Dockerfiles exist for both backends
- Both services defined in `docker-compose.yml` with healthcheck on `/health`
- IDX service has `depends_on` idx-postgres with `condition: service_healthy`
- Both services attached to the shared network

**Verification scenarios:**

- `/health` with database down — returns 200 (liveness is cheap, no external calls)
- IDX `/ready` with idx-postgres up — returns 200 with healthy status
- IDX `/ready` with idx-postgres down — returns 503 with unhealthy status
- Energy `/ready` — always returns 200 (placeholder)
- `/metrics` — returns Prometheus text format with at least default ASP.NET metrics
- Backend process killed and restarted by Docker — restarts cleanly and passes healthcheck

**Depends on:** 1

---

### V2. Validation: Gateway routes reach backend services

**After tasks:** 2, 3, 4, 5

**What to validate:** The API gateway correctly proxies requests to Keycloak and both stub backends based on URL path. ThingsBoard remains direct-access only.

**Validation scenarios:**

- `curl http://localhost/auth/realms/master` — returns Keycloak realm JSON with `/auth/` prefix in URLs- `curl http://localhost/idx/health` — returns 200 from IDX backend- `curl http://localhost/energy/health` — returns 200 from Energy backend- `curl http://localhost:9090/login` — ThingsBoard login page via direct port (not gateway)- `POST http://localhost/auth/realms/master/protocol/openid-connect/token` with invalid client — returns Keycloak error, not gateway 502 (confirms deep proxying, not just path match)- Open `http://localhost/auth/admin/` in browser, log in — admin console works through gateway without redirect errors
---

### 6. Add observability stack

Add Prometheus, Loki, and Grafana as Docker services. Configure Prometheus to scrape all service metrics, Loki to ingest container logs, and Grafana with pre-provisioned datasources and a basic health dashboard.

**Steps:**

1. Add Prometheus service with a mounted `prometheus.yml` config; configure scrape targets for IDX and Energy backends
2. Add Loki service; configure Docker log driver or Promtail sidecar to ship container logs to Loki
3. Add Grafana service with provisioned datasources (Prometheus and Loki) via config files — no manual setup on first boot
4. Create a basic system health dashboard via Grafana JSON provisioning: service up/down, container resource usage, request rates
5. Configure Grafana access credentials in `.env.template`

**Implementation requirements:**

- Prometheus config file defines scrape targets for all services exposing `/metrics`
- Loki service definition exists with a log ingestion path configured
- Grafana service has provisioned datasource configs for Prometheus and Loki (no manual setup)
- A dashboard JSON file exists and is mounted for Grafana provisioning
- Grafana credentials are sourced from environment variables
- All three services attached to the shared network

**Verification scenarios:**

- Prometheus `/targets` page — all configured scrape targets show state "UP"
- Prometheus query `up{}` — returns 1 for each target
- Grafana datasource list — Prometheus and Loki datasources present without manual configuration
- Grafana health dashboard — panels load and display data
- Generate a log line in IDX backend — line is queryable in Grafana via Loki within 30 seconds

**Depends on:** 5

---

### V3. Validation: Observability sees all services

**After tasks:** 5, 6

**What to validate:** Prometheus scrapes metrics from both stub backends and Loki ingests logs from all containers. Grafana renders live data without manual datasource setup.

**Validation scenarios:**

- Open Prometheus targets page — IDX and Energy backend targets show state "UP"- Query `up{}` in Prometheus — returns 1 for all configured targets- Open Grafana, navigate to health dashboard — panels render with live data- Search Loki in Grafana for IDX backend logs — log entries appear
---

### 7. Configure Compose profiles for local development

Add Compose profiles so developers can start only infrastructure dependencies for local IDE development, or the full stack including containerized backends, gateway, and observability. Document both workflows.

**Steps:**

1. Add `profiles: [full]` to `idx-backend`, `energy-backend`, and `gateway` services
2. Add `profiles: [observability, full]` to Prometheus, Loki, and Grafana services
3. Relax gateway `depends_on` so it does not block infrastructure-only startup
4. Verify `appsettings.Development.json` for each backend points to `localhost` with the exposed ports from `.env.template`
5. Document the two workflows (infrastructure-only and full stack) in `DEVELOPING.md`

**Implementation requirements:**

- Backend and gateway services have `profiles: [full]`
- Observability services have `profiles: [observability, full]`
- `appsettings.Development.json` connection strings use `localhost` with ports matching `.env.template`
- `DEVELOPING.md` exists with instructions for both workflows
- `docker compose config --services` (no profile) does not list backends, gateway, or observability services

**Verification scenarios:**

- `docker compose config --services` (no profile) — lists only infrastructure services; backends, gateway, prometheus, loki, grafana are absent
- `docker compose --profile full config --services` — lists all services
- `docker compose --profile observability config --services` — lists infrastructure + observability; backends and gateway absent
- `docker compose up -d` (no profile) then `docker compose ps` — only infrastructure services running
- Run IDX backend locally with `dotnet run` — `/health` returns 200 at localhost
- IDX backend `/ready` returns 200 — confirms connectivity to containerized idx-postgres via localhost
- `docker compose --profile full up -d` then `docker compose ps` — all services running

**Depends on:** 5, 6

---

### V4. Validation: Developer workflow (infra-only + local backend)

**After tasks:** 5, 6, 7

**What to validate:** A developer can start only infrastructure services, run a backend locally from their IDE, and connect to containerized dependencies through localhost ports.

**Validation scenarios:**

- `docker compose up -d` (no profile) then `docker compose ps` — only databases, Keycloak, and ThingsBoard running- Run IDX backend locally with `dotnet run`, `curl http://localhost:<local-port>/ready` — returns 200, confirming connectivity to containerized idx-postgres- `docker compose --profile full up -d` then `docker compose ps` — all services including backends, gateway, and observability running- `docker compose --profile observability up -d` then `docker compose ps` — infrastructure + observability, no backends or gateway
---

### 8. Validate full stack end-to-end

Run the full stack and systematically verify every service-to-service communication path, every healthcheck, and every gateway route.

**Steps:**

1. Run `docker compose --profile full up -d` and wait for all services to report healthy
2. Verify gateway routes: `/auth/` → Keycloak, `/idx/health` → 200, `/energy/health` → 200; verify ThingsBoard is reachable directly (not via gateway)
3. Verify internal connectivity: TB writes to tb-postgres, Keycloak writes to keycloak-postgres, IDX backend connects to idx-postgres
4. Verify cross-service reachability: IDX backend can reach ThingsBoard HTTP API and Keycloak on the internal network
5. Verify observability: Prometheus targets all UP, Loki receiving logs, Grafana dashboard visible
6. Document any configuration gotchas, workarounds, or deviations

**Implementation requirements:**

- A validation script or checklist document exists that covers all verification steps
- Any gotchas or non-obvious configuration steps are documented

**Verification scenarios:**

- All containers in `docker compose ps` show healthy status — no restarting or unhealthy containers
- `curl` each gateway route — correct upstream response
- `curl http://localhost:9090/login` — ThingsBoard login page (direct access)
- From inside IDX backend container, `curl http://thingsboard:8080/api/...` — TB responds on internal network
- From inside IDX backend container, `curl http://keycloak:8080/...` — Keycloak responds on internal network
- Stop Keycloak — gateway returns 502 for `/auth/*`, other routes unaffected
- Restart stopped service — gateway resumes routing within healthcheck interval

**Depends on:** 4, 5, 6, 7

---

### V5. Validation: Full stack end-to-end

**After tasks:** 4, 5, 6, 7, 8

**What to validate:** Every service-to-service path works, every gateway route responds, and observability covers the entire stack — the PLT-1 deliverable is complete.

**Validation scenarios:**

- `docker compose --profile full up -d && docker compose ps` — all services healthy- `curl http://localhost/auth/realms/master` — Keycloak realm JSON via gateway- `curl http://localhost/idx/health` — 200 via gateway- `curl http://localhost:9090/login` — ThingsBoard login page direct- From inside IDX container, `curl http://thingsboard:8080/api/...` — TB responds on internal network- From inside IDX container, `curl http://keycloak:8080/...` — Keycloak responds on internal network- Grafana health dashboard shows all services- Stop Keycloak, verify gateway returns 502 for `/auth/*` but other routes unaffected; restart Keycloak, verify routing resumes
---

### 9. Validate Windows Server deployment

Test the full Docker Compose stack on Windows Server 2022 with Hyper-V, measure resource overhead, evaluate Docker licensing options, and make a go/no-go decision on direct Windows Server support vs. shipping a pre-built Linux VM image.

**Steps:**

1. Provision a Windows Server 2022 VM with Hyper-V enabled (or use an existing one)
2. Install a Docker runtime (Docker Desktop, Mirantis Container Runtime, or Rancher Desktop) and document the choice
3. Run `docker compose up` with the full stack and verify all task 8 verification scenarios pass
4. Measure RAM overhead compared to Linux baseline with `docker stats`
5. Document Docker licensing implications for each runtime option
6. Write a decision record: support Windows Server directly, ship a Hyper-V Linux VM image, or both — with rationale

**Implementation requirements:**

- Decision record exists in `docs/decisions/` with Windows Server deployment rationale
- RAM overhead measurements documented with comparison to Linux baseline
- Docker licensing analysis covers Docker Desktop, Mirantis, and Rancher Desktop

**Verification scenarios:**

- `docker compose up -d` on Windows Server — all services reach healthy state (or document which fail and why)
- Run the same `curl` validation suite as task 8 — same results (or document differences)
- `docker stats` total RAM usage — documented delta vs. Linux baseline

**Depends on:** 8
