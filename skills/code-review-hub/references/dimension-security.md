# Dimension: security

Security review for the Target brief. Use discovered security guidance and general practice.

Read [shared-guardrails.md](shared-guardrails.md) first.

## Owns

- Injection, authentication and authorization gaps, secret leakage, unsafe defaults, untrusted input handling.
- Cryptographic misuse, session handling, CSRF and XSS where they apply to the stack.
- Issues called out in project security docs.

## Does not own

| Finding type | Primary dimension |
| ------------ | ----------------- |
| Non-security logic bugs | `implementation` |
| Missing acceptance criteria for a required security control | `intent` (this dimension still flags exploitable exposure) |
| Secure-coding rules in linter docs with no exploitable angle | `conformance` |

## Discovery

| Purpose | Sources |
| ------- | ------- |
| Security | `**/security.md`, security sections in convention docs, general judgment |
| Scope | Target brief acceptance criteria and Notes (do not require controls that are out of scope) |

## Report

Follow [shared-guardrails.md](shared-guardrails.md). Set `category` to `security`.