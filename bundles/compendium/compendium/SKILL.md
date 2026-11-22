---
name: compendium
description: Compendium workspace lifecycle in a host git repository — init, upgrade, migrate, and scope operations. Use when the user says compendium init, compendium upgrade, compendium migrate, or compendium scope.
metadata:
  author: zs
  version: "0.0.1"
---

# Compendium

## Outcome

Host repository is a valid Compendium instance with `scopes.yaml`, `contracts/`, `loci/`, and prek hooks as defined in the project seed.

## Guardrails

- Refuse operations outside a git work tree.
- One Compendium root per repository; no nested instance roots.
- Facet work uses facet skills (`wiki`, `academy`, …), not nested commands under `compendium`.

## Status

Initialization stub. Commands and scaffolds land in follow-up work.