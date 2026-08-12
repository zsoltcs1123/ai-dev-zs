# ARCHITECTURE.md Reference

Section reference and quality bar for the ARCHITECTURE.md produced by the project-architecture skill.

## Section Reference

Title: `# [Project Name] — Architecture`. Use `---` between sections. Required ●, optional ○.

| #   | Section                       | Req | Include When                          | Format                                                                  |
| --- | ----------------------------- | --- | ------------------------------------- | ----------------------------------------------------------------------- |
| 1   | System Overview               | ●   | Always                                | 1-2 paragraphs + ASCII diagram if >3 components + `**Core principle:**` |
| 2   | Components & Responsibilities | ●   | Always                                | Subsection per component with description or table                      |
| 3   | Data Architecture             | ●   | Always                                | Where data lives; include Data Flow if complex                          |
| 4   | Technology Stack              | ●   | Always                                | `\| Layer \| Technology \| Rationale \|` (no version numbers)           |
| 5   | Alternatives Considered       | ○   | Major tech choices with alternatives  | `\| Choice \| Alternative \| Why Rejected \|`                           |
| 6   | Infrastructure & Deployment   | ●   | Always                                | How and where it runs/ships; Deployment Models + Resource Requirements  |
| 7   | APIs & Integrations           | ○   | External systems or multiple services | Internal APIs + External Integrations tables                            |
| 8   | Multi-Tenancy Model           | ○   | SaaS or multi-tenant deployments      | Tenant/site isolation strategy                                          |
| 9   | Security & Compliance         | ○   | Auth complexity, sensitive data       | Auth Flow + Authorization + Data Protection                             |
| 10  | Scalability & Performance     | ○   | High-load or perf requirements        | Target Scale + Scaling Strategy tables                                  |
| 11  | Offline Resilience            | ○   | Must work without connectivity        | Cache strategy + behavior by scenario                                   |
| 12  | Observability                 | ○   | Production systems needing monitoring | `\| Component \| Technology \| Purpose \|`                              |
| 13  | Testing Strategy              | ○   | Complex test requirements             | `\| Level \| Scope \| Tools \|`                                         |
| 14  | Key Decisions & Tradeoffs     | ●   | Always                                | `\| Decision \| Rationale \| Tradeoff \|`                               |
| 15  | Future Considerations         | ○   | Known evolution paths                 | `\| Item \| Trigger \| Approach \|`                                     |
| 16  | Version History               | ●   | Always                                | `\| Version \| Date \| Changes \|`                                      |

## Quality Bar

Every decision must have rationale and acknowledged tradeoffs. Scale the document to the project — a simple project needs 1-2 pages; an enterprise system may need 10+. Only include sections that add value.
