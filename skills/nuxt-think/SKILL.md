---
name: nuxt-think
description: Explore Nuxt 4 + Vuetify 3 frontend requests, reuse the catalog when present, and return a structured design brief without editing code.
---

# Nuxt Think

## Purpose

Clarify what to build before frontend implementation. Consult `components.meta.json` when it exists, or `.generated/component-catalog/components.meta.json` when the project ships the slim catalog mirror, ask only the minimum useful questions, and challenge weak component boundaries.

Use this skill instead of `nestjs-think` when the request is clearly Nuxt/Vuetify-first.

This skill owns discovery and design closure for frontend work. Resolve UI structure, reuse choices, state ownership, user interactions, and responsive behavior here so `nuxt-plan` can stay focused on execution topology.

Before closing decisions, locate the nearest `GUIDELINES.md` for the feature area you are shaping. Start from the likely ownership directory for the route, page, or domain component, then walk upward. If both local and root-level guideline files exist, the closer file wins and the broader file is fallback only.

## Flow

1. Read `components.meta.json` when available. Fall back to `.generated/component-catalog/components.meta.json` when the project exposes only the slim catalog.
2. Read the nearest `GUIDELINES.md` that applies to the target area. If none exists, note that explicitly, continue, and suggest bootstrapping one from `skills/nuxt-audit/reference/guidelines-template.md`.
3. Classify the request as simple, medium, or complex.
4. Search for reusable components by `tags`, `category`, and `domain`. Use `useWhen` only when the rich catalog includes it.
5. Ask focused follow-up questions only when the request still has material ambiguity.
6. Close the design decisions that matter for implementation:
   - what screen, route, modal, or dashboard slice owns the work
   - which existing components are reused versus newly created
   - what loading, empty, error, and success states must exist
   - what user interactions change navigation, filtering, or local state
   - what responsive layout shifts matter
   - what existing primitives, shells, or local patterns from `GUIDELINES.md` must be preferred
   - what visual direction should guide the UI so it does not drift into generic output
7. Produce the structured output below and stop. Do not write code.

Read `reference/conventions.md` before proposing component splits.

## Think Output

### O que construir

Describe the requested page, flow, or component in one sentence.

### Componentes a reutilizar

- `ProjectStatusBadge` - reuse when the request needs project lifecycle display.

### Componentes a criar

- `ProjectDetailsSidebar` - summarize project metadata and actions.

### Composables/Utils/Config

- `useProjectDetails` - keep reactive fetch and transformation logic outside the page component.

### Decisoes tomadas

- Split the header and sidebar because the concerns and reuse surface are different.

### Direcao visual

- State the intended tone in one short line.
- Prefer existing shells, spacing, and primitives from `GUIDELINES.md` before inventing new presentation patterns.
- Call out any anti-genericity guardrails that matter for this feature, such as density, emphasis, or when to stay visually quiet.

### Estados e interacoes

- Loading: show skeletons in the main content area.
- Empty: show a neutral empty state when no records exist.
- Error: show inline retry feedback near the failing block.
- Interaction: sidebar actions trigger navigation and local refresh only.

### Responsividade

- Collapse the sidebar below tablet width.
- Preserve the header summary above the content stack on mobile.

### Pronto para planejar

- Route ownership, reuse decisions, state behavior, and responsive behavior are closed.
- The relevant `GUIDELINES.md` constraints and visual direction are closed.
- `nuxt-plan` should only turn this into exact file paths, dependency order, and execution groups.
