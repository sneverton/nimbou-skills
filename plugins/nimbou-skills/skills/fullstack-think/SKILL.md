---
name: fullstack-think
description: Use for mixed frontend and backend requests. Close shared domain and integration decisions once, then dispatch `nuxt-plan` and `nestjs-plan` in parallel and reconcile the resulting plans.
---

# Fullstack Think

Use this skill when the request changes both frontend and backend in the same feature slice, or when frontend delivery depends on a new or changed backend contract.

If the request is frontend-only, use `nuxt-think`.
If the request is backend-only, use `nestjs-think`.

## Domain Specification Gate

Before planning:

1. identify the target domain
2. use `mapping-domain-states` to create or update `docs/domain/<domain>/domain.md`
3. use `generating-gherkin-specs` to create or update `docs/domain/<domain>/*.feature`
4. present the domain and Gherkin changes for approval
5. close the shared HTTP, event, or state contract that both plans need
6. do not advance with stale domain or Gherkin artifacts

## Planning Flow

1. confirm the request is genuinely mixed
2. close shared specification and contract decisions
3. split the work into a frontend slice and a backend slice
4. dispatch `nuxt-plan` and `nestjs-plan` in parallel
5. reconcile the plans for contract, naming, ordering, and dependency alignment
6. block execution if the two plans disagree on the same feature contract

## Reconciliation Output

- shared contract
- recommended execution order
- cross-plan dependencies
- alignment risks
