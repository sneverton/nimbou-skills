---
description: Guided feature development for backend-only, frontend-only, or fullstack work using the local think and plan skills plus specialized explorer, architect, and reviewer agents.
argument-hint: Optional feature description
---

# Feature Development

You are helping a developer implement a new feature. Follow a systematic approach: understand the codebase, close ambiguities, design the approach deliberately, then implement with review.

## Core Principles

- Ask clarifying questions before implementation when requirements are underspecified
- Read and understand existing code patterns before changing them
- Use specialized agents for exploration, architecture comparison, and review
- Classify the feature as backend-only, frontend-only, or fullstack before choosing the local think and plan skills
- Keep progress visible and do not skip user approval gates

## Phase 1: Discovery

Goal: understand what needs to be built.

Actions:
1. Capture the initial request from `$ARGUMENTS`
2. If the feature is unclear, ask what problem is being solved, what the feature should do, and what constraints matter
3. Summarize your understanding and confirm with the user
4. Classify the request:
   - backend-only: API, rules, jobs, persistence, contracts, or architecture changes without Nuxt UI work
   - frontend-only: Nuxt/Vuetify page, component, layout, interaction, or catalog-driven work without backend contract changes
   - fullstack: both backend and frontend change, or frontend depends on a new or changed backend contract

## Phase 2: Codebase Exploration

Goal: understand relevant existing code and patterns.

Actions:
1. Launch 2-3 `code-explorer` agents in parallel
2. Give each explorer a different angle:
   - similar features and implementation traces
   - architectural boundaries and abstractions
   - UI patterns, extension points, tests, or integration surfaces
3. Require each agent to return:
   - concise findings
   - key risks or conventions
   - 5-10 key files to read
4. Read the returned files before moving on
5. Summarize the findings for the user

## Phase 3: Clarifying Questions

Goal: close all material ambiguities before design.

Actions:
1. Review the feature request and exploration findings
2. Identify missing details around scope, edge cases, contracts, integration points, compatibility, and performance
3. Present the questions in a clear organized list
4. Wait for the user's answers before designing

## Phase 4: Architecture and Design

Goal: produce design alternatives with trade-offs.

Actions:
1. Launch 2-3 `code-architect` agents in parallel with different focus lenses:
   - minimal changes
   - clean architecture
   - pragmatic balance
2. Review the returned approaches and form your recommendation
3. Present the trade-offs and ask the user which approach they want
4. Route to the local skills:
   - backend-only: `nestjs-think` then `nestjs-plan`
   - frontend-only: `nuxt-think` then `nuxt-plan`
   - fullstack: `nestjs-think`, `nestjs-plan`, `nuxt-think`, `nuxt-plan`
5. Hard rules:
   - do not start `nuxt-think` when the frontend depends on an unsettled backend contract
   - do not let backend discovery redesign frontend UI structure
   - do not let frontend discovery redefine backend rules or persistence semantics

## Phase 5: Implementation

Goal: build the approved feature.

Actions:
1. Do not start without explicit user approval
2. Follow the selected architecture and the generated plan or plans
3. Use `subagent-driven-development` or `executing-plans` when the workflow calls for execution
4. Keep backend and frontend boundaries intact

## Phase 6: Quality Review

Goal: ensure the implementation is correct, maintainable, and aligned with the plan.

Actions:
1. Launch 3 `code-reviewer` agents in parallel with distinct focuses:
   - bugs and functional correctness
   - simplicity, DRY, and maintainability
   - project conventions and architectural alignment
2. Consolidate only the findings that matter
3. Present the review findings and ask the user whether to fix now, defer, or proceed

## Phase 7: Summary

Goal: close the workflow clearly.

Actions:
1. Summarize what was built
2. Summarize key design decisions
3. List the most important files changed
4. List any follow-up work or residual risks
