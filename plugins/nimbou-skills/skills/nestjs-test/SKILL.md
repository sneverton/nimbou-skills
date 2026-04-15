---
name: nestjs-test
description: Stabilize and expand backend HTTP and persistence tests from approved Gherkin, routing audit work through the NestJS backend auditors.
---

# NestJS Test

## Purpose

Own gherkin-driven backend test generation, audit dispatch, and stabilization for NestJS modules and Prisma repositories.

## When to Use

Use this skill when approved Gherkin exists and a backend surface needs explicit HTTP, E2E, or persistence coverage.

## Modes

- **gherkin-driven mode** - use approved `docs/domain/<domain>/*.feature` files to add or expand backend coverage
- **audit mode** - dispatch `nestjs-http-test-auditor` or `prisma-repository-test-auditor`
- **stabilize mode** - tighten fragile backend tests without weakening observable contracts

## Rules

- do not invent scenarios outside approved Gherkin
- choose one module or persistence slice at a time
- keep HTTP and Prisma confidence explicit instead of mixing them implicitly
- use the existing backend audit agents as internal execution tools, not as user-facing skills
