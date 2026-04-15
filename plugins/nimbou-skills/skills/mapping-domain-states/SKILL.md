---
name: mapping-domain-states
description: Map one business domain into a compact glossary, entities, states, transitions, and derived statuses before planning or test generation.
---

# Mapping Domain States

## Purpose

Create or update `docs/domain/<domain>/domain.md` as the shared source of truth for domain terms, entities, states, transitions, and derived statuses.

## Output

- `docs/domain/<domain>/domain.md`
- keep the document compact and domain-centered
- prefer business language over framework or database language

## Rules

- support only Claude Code and Codex
- document one domain per run
- write states in `UPPER_CASE`
- keep derived statuses separate from real states
- do not include Prisma models, DTO fields, HTTP routes, or class names
