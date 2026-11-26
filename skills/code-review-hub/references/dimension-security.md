# Dimension: security

Security review for the Target brief. Use discovered security guidance and general practice.

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

## Severity

Judge **exploitability in realistic conditions** and **blast radius**. Do not set severity from CWE name, scanner label, or security-doc section alone.

- **Major:** Attacker or untrusted input can reach the flaw in paths this change opens; secrets leak; auth can be bypassed; data crosses trust boundaries without control.
- **Medium:** Weak control on touched code; missing validation where input arrives but exploit needs chaining; issue is serious on paper but not shown reachable in this diff.
- **Minor:** Defense in depth; hardening with no plausible exploit path introduced by this change.

## Report

Set `category` to `security`.
