---
name: nestjs-audit-prisma-repositories
description: Use when auditing, fixing, stabilizing, or expanding Prisma repository and persistence integration tests against a real test database
---

# Audit Prisma Repositories

Dispatch `prisma-repository-test-auditor` when a Prisma-backed persistence boundary needs real-database confidence.

**Core principle:** Validate persistence semantics against the real test database, not a mocked approximation.

## When to Use

Use this skill when:
- a Prisma repository changed and integration coverage needs review
- schema or migration changes made persistence tests inconsistent
- filters, ordering, pagination, transactions, or relation loading need verification
- repository tests are flaky because of fixtures, cleanup, or schema assumptions

Do not use this skill for controller or route-level HTTP confidence. Use `nestjs-audit-http-tests` for that.

## Required Inputs

Before dispatching the auditor, gather:
- target repository, query service, or persistence adapter
- target test files or test command for that persistence area
- expected persistence behavior or contract
- any known failing tests or suspected query/schema regressions
- the real test database assumptions for the project

If the request is broad, reduce it to one repository or persistence slice first.

## How to Run

Use Task tool with `prisma-repository-test-auditor`.

Include:
- what repository or persistence module changed
- which tests or command cover that area
- what persistence behavior must be preserved
- any relevant schema, transaction, fixture, or cleanup assumptions

## Dispatch Template

```text
Task tool (prisma-repository-test-auditor):
  TARGET: [repository or persistence module]
  TEST_SCOPE: [test file(s) or command]
  EXPECTED_BEHAVIOR: [filters, writes, pagination, transactions, etc.]
  KNOWN_ISSUES: [optional failures, flakes, or suspected regressions]
  CONTEXT: [schema, cleanup strategy, fixtures, real DB assumptions]
```

## After the Audit

- Fix Critical persistence issues immediately
- Fix Important issues before claiming repository confidence
- Keep Minor issues visible if they can wait
- If the auditor proposes repository changes, verify the issue is a real query, mapping, or transaction defect rather than a bad test fixture

## Red Flags

Never:
- replace real-database repository confidence with mocks
- broaden the audit into controllers or frontend behavior
- weaken assertions around filtering, relation loading, transactions, or constraints
- audit multiple unrelated persistence areas in one pass
