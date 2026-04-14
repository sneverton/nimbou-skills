# Nuxt Frontend DESIGN.MD Template

Use this file as the starting point for a project- or feature-level `DESIGN.MD`.

The goal is to give `nuxt-think`, `nuxt-plan`, and `nuxt-audit` a local source of truth for:
- page and component responsibilities
- composable and util boundaries
- preferred UI primitives and layout shells
- data flow decisions
- visual guardrails
- review and audit expectations

When a feature area has its own closer `DESIGN.MD`, that local file should override a broader project- or app-level one for that subtree.

---

## Purpose

Use this document to align:
- page and component responsibilities
- composable and util boundaries
- preferred UI primitives and layout shells
- data flow decisions
- visual guardrails
- review and audit expectations

If a repeated pattern becomes stable, update this file instead of rewriting the same rationale in one-off plans.

---

## Product and Interface Context

- Who uses this app or feature
- What job they are trying to get done
- What tone the interface should communicate
- What this should explicitly avoid looking like

---

## Component Responsibility Model

### Page

A page owns:
- route params, query sync, and navigation
- initial data loading and top-level orchestration
- high-level actions that affect the whole route
- passing stable props into child sections

A page should not accumulate child-only handlers, display-only transforms, or repeated local interaction logic.

### Domain Component

A domain component owns:
- local rendering logic
- local interaction flow
- local validation and formatting
- emits only when a parent truly owns the next decision

Prefer solving child-local behavior inside the child rather than bouncing every action back to the page.

### Composable

Use a composable when:
- logic is reactive
- state or behavior is reused
- async work needs loading or error state
- the page or component script is getting too large

### Util

Use a util when:
- logic is pure
- no reactive state is needed
- the same transform is reused in multiple places

### Config

Use config when the feature is mostly declarative:
- tabs
- sections
- menu items
- table columns
- step lists

---

## Reuse and Extraction Rules

- Repeated semantic markup should become a component.
- Repeated reactive behavior should become a composable.
- Repeated static definitions should become config.
- Do not extract speculative reuse. The second real consumer is the normal trigger.
- Prefer existing primitives and shells before creating local wrappers.

---

## Data Flow

- Keep state as local as possible while still serving all consumers.
- Prefer direct props plus emits for parent-child communication.
- Use composables or provide/inject when prop drilling becomes unnatural.
- Introduce Pinia only when state must survive route boundaries or sync across unrelated trees.

Anti-patterns:
- page with 20+ handlers for child-local actions
- prop drilling across 3+ levels without a strong reason
- local UI fixes hiding stale or duplicated reactive state
- store creation for one narrow parent-child interaction

---

## UI Primitives and Layout

- Prefer established page shells, section shells, and form/layout primitives before inventing new wrappers.
- Prefer simple, legible composition over deep nesting.
- Layout should create clear hierarchy through spacing, grouping, and emphasis.
- Responsive behavior should adapt the interaction model, not just compress the same layout.

---

## Visual Guardrails

- Avoid generic AI-looking UI patterns and safe filler layouts.
- Choose a clear density and emphasis level per feature.
- Keep visual weight aligned with action importance.
- Loading, empty, error, and success states must feel like part of the same interface, not bolted-on afterthoughts.
- Reuse existing visual primitives before introducing new accents, borders, or one-off containers.

---

## Hardening Expectations

Every significant flow should account for:
- loading
- empty
- error
- success
- long text
- missing data
- large collections
- small screens
- likely i18n expansion

If a feature cannot survive those cases, it is not ready.

---

## Performance Expectations

- Avoid duplicate fetches and overlapping watchers.
- Guard browser-only APIs when SSR or hydration is involved.
- Prefer observable state transitions over timeout-based sequencing.
- Keep assets, requests, and reactive work proportional to the feature.

---

## Naming and Organization

- Keep names domain-first and intention-revealing.
- Put domain components near their feature area.
- Keep shared primitives and broad UI building blocks clearly separated from domain components.
- Favor predictable file placement over clever naming.

---

## Audit Expectations

Frontend review should check:
- ownership and architecture
- reuse and extraction
- hardening gaps
- performance issues
- polish and consistency drift
- Nuxt and Vuetify conventions
- catalog health when reusable components exist

---

## When To Update This File

Update `DESIGN.MD` when:
- a pattern becomes stable and repeatable
- a recurring refactor keeps reaching the same conclusion
- a shared primitive becomes the preferred solution
- a review rule should become explicit instead of being rediscovered each time
