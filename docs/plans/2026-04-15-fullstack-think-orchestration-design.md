# Fullstack Think Orchestration Design

**Goal:** Add a `fullstack-think` orchestrator for mixed frontend and backend requests so the repository can close shared specification once, generate `nuxt-plan` and `nestjs-plan` in parallel, and reconcile both plans before execution.

## Problem

The repository currently has strong platform-specific entry points:

- `nuxt-think` -> `nuxt-plan`
- `nestjs-think` -> `nestjs-plan`

That separation is good for single-surface work, but mixed requests still force an awkward choice:

- start from `nuxt-think` and underspecify backend concerns
- start from `nestjs-think` and underspecify frontend concerns
- run both manually and risk drift between shared states, contracts, and plan ordering

The repository now has a shared specification layer through `docs/domain/<domain>/domain.md` and `docs/domain/<domain>/*.feature`. Mixed requests should use that layer once, then branch into platform-specific planning without reopening approved product decisions.

## Approved Design

### 1. Add `fullstack-think` as a mixed-request orchestrator

Create a new skill:

- `fullstack-think`

Its role is narrow and explicit:

- handle requests that genuinely change frontend and backend in the same feature slice
- preserve `nuxt-think` for frontend-only requests
- preserve `nestjs-think` for backend-only requests
- redirect to the platform-specific skill when the request is not truly mixed

`fullstack-think` is not a replacement for the existing think skills. It is the orchestration entry point for fullstack changes only.

### 2. Keep shared specification as the first gate

Before any planning starts, `fullstack-think` must complete the same shared specification gate already used elsewhere:

1. identify the target domain
2. invoke `mapping-domain-states`
3. invoke `generating-gherkin-specs`
4. present `docs/domain/<domain>/domain.md` and affected `.feature` files for approval
5. close the shared contract that affects both frontend and backend

This gate must explicitly close:

- domain entities and state transitions
- user-visible and backend-visible scenario coverage
- shared HTTP or event contract when relevant
- assumptions that both plans need in order to proceed safely

No parallel planning happens before this gate is approved.

### 3. Split one approved request into two planning slices

After the shared specification gate is closed, `fullstack-think` decomposes the approved work into:

- a **frontend slice** for `nuxt-plan`
- a **backend slice** for `nestjs-plan`

The split is structural, not product-level. `fullstack-think` does not create two independent features. It creates two planning views over the same approved feature so each platform-specific planning skill can stay focused on its own file topology and execution model.

The frontend slice should include:

- route or page ownership
- component reuse or creation decisions already approved
- composables, local state, and responsive behavior
- frontend validation and test suggestions

The backend slice should include:

- module and use-case boundaries
- transport or contract shape
- repository and Prisma ownership
- backend validation and test strategy

### 4. Plan in parallel by default after the contract is stable

Once the shared contract is closed, `fullstack-think` should dispatch planning in parallel by default:

- one agent runs `nuxt-plan`
- one agent runs `nestjs-plan`

Parallel planning is allowed only when the shared gate has already made these items stable:

- domain and transitions
- names of relevant states or scenarios
- shared integration contract
- strong dependencies between UI behavior and backend behavior

If those items are still ambiguous, `fullstack-think` must stop and resolve them before dispatching any planning agent.

### 5. Reconcile the plans before execution

When both planning agents return, `fullstack-think` produces one reconciliation pass. This pass does not reopen product design. It validates that both plans are mutually executable.

The reconciliation output must include:

- **Shared contract** — payloads, names, states, scenarios, and integration assumptions used by both plans
- **Recommended execution order** — `backend-first`, `frontend-first`, or parallel-by-group
- **Cross-plan dependencies** — files, interfaces, data contracts, or blockers one plan needs from the other
- **Alignment risks** — conflicts that must be fixed before execution starts

If one plan assumes behavior, naming, or contract details not reflected in the other plan, `fullstack-think` treats that as a reconciliation failure and blocks execution until corrected.

### 6. Keep implementation handoff explicit

`fullstack-think` ends with a combined handoff, not direct coding.

The final output should:

1. summarize the approved shared contract
2. present the frontend and backend plans together
3. state the recommended execution order
4. list cross-plan dependencies and blockers
5. hand off to the existing execution skills rather than inventing a new executor

This keeps the repository aligned with its current workflow:

- think skills close design
- plan skills define implementation topology
- execution skills implement approved plans

## Final Skill Topology

### Shared specification layer

- `mapping-domain-states`
- `generating-gherkin-specs`

### Think entry points

- `nuxt-think`
- `nestjs-think`
- `fullstack-think`

### Plan entry points

- `nuxt-plan`
- `nestjs-plan`

### Execution layer

- `executing-plans`
- `subagent-driven-development`

## Behavioral Expectations

- frontend-only requests stay in `nuxt-think`
- backend-only requests stay in `nestjs-think`
- mixed requests enter `fullstack-think`
- mixed requests close shared specification once before planning
- planning runs in parallel by default only after the shared contract is stable
- execution is blocked when the two plans disagree on the same feature contract

## Repository Impact

The implementation should cover at least:

1. add `plugins/nimbou-skills/skills/fullstack-think/SKILL.md`
2. update `README.md` to document the new mixed-request entry point
3. update skill-tree and manifest tests to include the new skill and its workflow references
4. preserve `nuxt-think` and `nestjs-think` as specific entry points rather than collapsing them into one hybrid skill
5. make agent parallelization explicit as a planning-stage behavior, not a specification-stage behavior

## Guardrails

- do not use `fullstack-think` for single-surface work
- do not bypass shared specification approval before parallel planning
- do not let reconciliation silently paper over naming or contract conflicts
- do not merge frontend and backend planning rules into one generic planning flow
- do not introduce a new execution skill when the current execution layer already fits
