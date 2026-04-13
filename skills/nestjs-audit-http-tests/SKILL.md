---
name: nestjs-audit-http-tests
description: Use when auditing, fixing, stabilizing, or expanding NestJS HTTP/controller tests for a specific module or route surface
---

# Audit NestJS HTTP Tests

Dispatch `nestjs-http-test-auditor` when a NestJS module needs route-level test confidence.

**Core principle:** Audit one HTTP surface at a time. Keep the scope at controller, route, auth, validation, filter, and serialization behavior.

## When to Use

Use this skill when:
- a controller changed and the HTTP tests need review
- endpoint validation, auth, or error mapping became flaky
- route coverage is missing or stale
- you need confidence in request/response behavior without drifting into repository internals

Do not use this skill for deep Prisma or repository confidence. Use `nestjs-audit-prisma-repositories` for that.

## Required Inputs

Before dispatching the auditor, gather:
- target module or controller
- target test files or test command for that module
- the expected route behavior or contract
- any known failing tests or fragile flows

If the request is vague, narrow it to one module first.

## How to Run

Use Task tool with `nestjs-http-test-auditor`.

Include:
- what module or controller changed
- which routes or behaviors need auditing
- where the relevant tests live
- how to run only the relevant HTTP tests
- any special auth, bootstrap, or request-context assumptions

## Dispatch Template

```text
Task tool (nestjs-http-test-auditor):
  TARGET: [module or controller]
  TEST_SCOPE: [test file(s) or command]
  EXPECTED_BEHAVIOR: [HTTP contract to preserve or validate]
  KNOWN_ISSUES: [optional failures, flakes, or missing cases]
  CONTEXT: [auth, guards, filters, interceptors, multipart, etc.]
```

## After the Audit

- Fix Critical issues immediately
- Fix Important issues before claiming confidence
- Keep Minor issues visible if they can wait
- If the auditor proposes controller changes, verify the issue is a real route-level defect rather than a weak test

## Red Flags

Never:
- audit multiple unrelated modules in one pass
- replace route-level assertions with unit-only mocks
- weaken endpoint assertions just to make tests pass
- use this skill when the real problem is persistence semantics
