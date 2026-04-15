# Domain and Gherkin Skill Integration Design

**Goal:** Integrate domain mapping and Gherkin generation into the `nimbou-skills` workflow so the same approved specification artifacts can drive frontend planning, backend planning, and test generation.

## Problem

The external skills `mapping-domain-states`, `generating-gherkin-specs`, and `generating-playwright-tests` form a good pipeline, but the current repository already has `nuxt-think`, `nestjs-think`, `nuxt-plan`, and backend audit agents. Copying the pipeline as-is would duplicate test-oriented skills, scatter specification artifacts, and keep too much upstream-specific surface area.

## Approved Design

### 1. Domain-centered document layout

Store specification artifacts by domain, not by artifact type.

```text
docs/domain/
  <domain>/
    domain.md
    <feature-a>.feature
    <feature-b>.feature
```

Rules:

- `domain.md` is the compact source of truth for glossary, entities, states, transitions, and derived states.
- `.feature` files live in the same domain directory so domain context and executable scenarios stay co-located.
- Any skill that needs specification context resolves it from `docs/domain/<domain>/`.

### 2. Shared specification skills

Keep two reusable skills as the shared specification layer:

- `mapping-domain-states`
- `generating-gherkin-specs`

Adapt them to this repository:

- keep support limited to Claude Code and Codex
- rewrite descriptions and examples toward NestJS, Prisma, Clean Architecture, SOLID, and the local test workflow
- make the output path domain-centered:
  - `docs/domain/<domain>/domain.md`
  - `docs/domain/<domain>/*.feature`

These skills are not frontend-only or backend-only. They become shared inputs for planning, testing, and future review skills.

### 3. Orchestration through `nuxt-think` and `nestjs-think`

`nuxt-think` and `nestjs-think` become the entry points that close specification before planning.

Required flow:

1. receive the request
2. identify the target domain
3. create or update `docs/domain/<domain>/domain.md`
4. create or update `docs/domain/<domain>/*.feature`
5. present the domain and Gherkin changes for approval
6. only after approval, hand off to `nuxt-plan` or `nestjs-plan`

Guardrails:

- no plan generation from stale domain or Gherkin artifacts
- if the request spans multiple independent domains, split them and approve one domain at a time
- any state-transition change requires regenerating the affected `.feature` files before planning

### 4. Test skill integration

Do not keep `generating-playwright-tests` as a standalone skill.

Instead:

- extend `nuxt-test` so approved Gherkin can drive Playwright coverage generation and expansion
- add a new `nestjs-test` skill so approved Gherkin can drive NestJS HTTP and E2E test generation and expansion

This makes Gherkin the shared contract, while platform-specific test skills remain responsible for framework conventions and observable assertions.

### 5. Backend audit surface simplification

Remove these thin wrapper skills:

- `nestjs-audit-http-tests`
- `nestjs-audit-prisma-repositories`

Keep their agents:

- `nestjs-http-test-auditor`
- `prisma-repository-test-auditor`

Move the user-facing backend test entry point to `nestjs-test`, which can support:

- **gherkin-driven mode** for new or missing test coverage
- **audit mode** for route-level or repository-level review through the existing agents
- **stabilize mode** for tightening fragile tests

This keeps the interface smaller while preserving the specialized agent capabilities.

## Final Skill Topology

### Shared specification layer

- `mapping-domain-states`
- `generating-gherkin-specs`

### Design and planning entry points

- `nuxt-think`
- `nestjs-think`
- `nuxt-plan`
- `nestjs-plan`

### Test entry points

- `nuxt-test`
- `nestjs-test`

### Internal backend audit agents

- `nestjs-http-test-auditor`
- `prisma-repository-test-auditor`

## Behavioral Expectations

- domain and Gherkin artifacts are reusable across multiple skills
- planning is blocked until specification artifacts are updated and approved
- test generation follows approved Gherkin instead of inventing new scenarios
- backend agents remain internal execution mechanisms rather than user-facing skills

## Migration Notes

1. import and adapt `mapping-domain-states`
2. import and adapt `generating-gherkin-specs`
3. update `nuxt-think` to orchestrate domain and Gherkin creation or revision before `nuxt-plan`
4. update `nestjs-think` to orchestrate domain and Gherkin creation or revision before `nestjs-plan`
5. merge the useful generation logic from `generating-playwright-tests` into `nuxt-test`
6. create `nestjs-test` as the backend counterpart
7. remove the two thin NestJS audit skills while keeping the agents
