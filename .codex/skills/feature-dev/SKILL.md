---
name: feature-dev
description: Guided feature development for backend-only, frontend-only, or fullstack work using the local think and plan skills plus specialized explorer, architect, and reviewer agents.
---

# Feature Development

Use this skill when the user wants to build a feature and needs a disciplined path from discovery to review.

## Core Principles

- Ask clarifying questions before implementation when requirements are underspecified
- Read and understand existing code patterns before changing them
- Use specialized agents for exploration, architecture comparison, and review
- Classify the feature as backend-only, frontend-only, or fullstack before choosing the local think and plan skills
- Keep progress visible and do not skip user approval gates

## Phase 1: Discovery

1. Capture the current user request from the conversation.
2. If the feature is unclear, ask what problem is being solved, what the feature should do, and what constraints matter.
3. Classify the request:
   - backend-only: API, rules, jobs, persistence, contracts, or architecture changes without Nuxt UI work
   - frontend-only: Nuxt/Vuetify page, component, layout, interaction, or catalog-driven work without backend contract changes
   - fullstack: both backend and frontend change, or frontend depends on a new or changed backend contract

## Phase 2: Codebase Exploration

1. Launch 2-3 `code-explorer` agents in parallel.
2. Split them across implementation traces, architecture boundaries, and UI or test surfaces.
3. Read the returned files before moving on and summarize the findings for the user.

## Phase 3: Clarifying Questions

1. Review the feature request and exploration findings.
2. Identify missing details around scope, edge cases, contracts, integration points, compatibility, and performance.
3. Ask only what still blocks design.

## Phase 4: Architecture and Design

1. Launch 2-3 `code-architect` agents in parallel with minimal changes, clean architecture, and pragmatic balance lenses.
2. Route to the local skills:
   - backend-only: `nestjs-think` then `nestjs-plan`
   - frontend-only: `nuxt-think` then `nuxt-plan`
   - fullstack: `nestjs-think`, `nestjs-plan`, `nuxt-think`, `nuxt-plan`
3. Do not let backend discovery redesign frontend UI structure or let frontend discovery redefine backend semantics.
4. **Phase 4: Architecture and Design** is where the user picks the approach.

## Phase 5: Implementation

1. Do not start without explicit user approval.
2. Follow the selected architecture and the generated plan or plans.
3. Use `subagent-driven-development` or `executing-plans` when execution is split into independent work.

## Phase 6: Quality Review

1. Launch 3 `code-reviewer` agents in parallel for correctness, maintainability, and conventions.
2. Present only findings that matter.
3. Ask whether to fix now, defer, or proceed.

## Phase 7: Summary

1. Summarize what was built.
2. Summarize key design decisions.
3. List the most important files changed and any residual risks.
