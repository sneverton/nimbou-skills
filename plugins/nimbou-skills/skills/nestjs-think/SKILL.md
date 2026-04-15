---
name: nestjs-think
description: "Use before backend design or implementation work. Drive NestJS, Prisma, Clean Architecture, and SOLID decisions into an approved design before code changes."
---

# NestJS Think

Turn backend requests into concrete NestJS-first designs before code changes. This skill is not stack-neutral: default to `NestJS + Prisma + Clean Architecture + SOLID`.

When the request is clearly frontend-first for Nuxt/Vuetify, use `nuxt-think` instead of forcing this workflow.

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it.
</HARD-GATE>

## Domain Specification Gate

Before writing the implementation plan:

1. identify the target business domain
2. use `mapping-domain-states` to create or update `docs/domain/<domain>/domain.md`
3. use `generating-gherkin-specs` to create or update `docs/domain/<domain>/*.feature`
4. present the domain and Gherkin changes for approval
5. do not advance to `nestjs-plan` with stale domain or Gherkin artifacts
6. if state transitions changed, regenerate the affected `.feature` files before planning
7. do not do the `domain.md` or `*.feature` work inline inside `nestjs-think`; delegate it to the shared spec skills
8. if the request splits into multiple independent domains, split them and close one domain at a time
9. only after approval, invoke `nestjs-plan`

Treat the domain directory as the approved contract for backend planning, route coverage, and later test generation.

## Checklist

You MUST create a task for each of these items and complete them in order:

1. **Explore project context** — inspect modules, Prisma schema, tests, docs, and recent commits
2. **Ask clarifying questions** — one at a time, understand purpose, boundaries, contracts, and success criteria
3. **Propose 2-3 backend approaches** — with trade-offs and your recommendation
4. **Present the design** — emphasize modules, boundaries, contracts, persistence, and tests
5. **Write design doc** — save to `docs/plans/YYYY-MM-DD-<topic>-design.md`
6. **Spec self-review** — check placeholders, contradictions, ambiguity, and boundary drift
7. **User reviews written spec** — ask the user to review the file before proceeding
8. **Transition to implementation** — only after approval, invoke `nestjs-plan`

## Process Flow

```dot
digraph nestjs_think {
    "Explore project context" [shape=box];
    "Ask clarifying questions" [shape=box];
    "Propose 2-3 backend approaches" [shape=box];
    "Present design sections" [shape=box];
    "User approves design?" [shape=diamond];
    "Write design doc" [shape=box];
    "Spec self-review" [shape=box];
    "User reviews spec?" [shape=diamond];
    "Invoke nestjs-plan" [shape=doublecircle];

    "Explore project context" -> "Ask clarifying questions";
    "Ask clarifying questions" -> "Propose 2-3 backend approaches";
    "Propose 2-3 backend approaches" -> "Present design sections";
    "Present design sections" -> "User approves design?";
    "User approves design?" -> "Present design sections" [label="no, revise"];
    "User approves design?" -> "Write design doc" [label="yes"];
    "Write design doc" -> "Spec self-review";
    "Spec self-review" -> "User reviews spec?";
    "User reviews spec?" -> "Write design doc" [label="changes requested"];
    "User reviews spec?" -> "Invoke nestjs-plan" [label="approved"];
}
```

## Understanding the Request

- Check the current project state first: modules, controllers, DTOs, use-cases, repositories, Prisma schema, test suites, and recent commits.
- If the request describes multiple independent subsystems, decompose it before refining details. Each subsystem should get its own spec and later its own implementation plan.
- Ask one question per message. Prefer multiple choice when it keeps the answer precise.
- Focus on:
  - public contract: HTTP, jobs, events, or internal use-case API
  - boundary placement: controller, application, domain, infrastructure
  - persistence shape: repository contracts, Prisma queries, transactions
  - constraints: auth, validation, idempotency, migrations, observability
  - success criteria and test evidence

## Exploring Approaches

- Propose 2-3 backend approaches with trade-offs.
- Lead with your recommendation and explain why.
- Explicitly discuss:
  - module boundaries
  - dependency direction
  - repository and use-case responsibilities
  - where Prisma belongs and where it must not leak
  - how SOLID influences the design

## Presenting the Design

Cover, when relevant:

- module structure
- request or command flow
- DTOs, validation, guards, filters, and serialization
- use-cases and service boundaries
- repository contracts and Prisma adapters
- transaction boundaries and error mapping
- test strategy across HTTP, application, and persistence layers

Ask after each section whether it looks right so far. If something is wrong or vague, revise before moving on.

## Design Rules

- Break the system into units with one clear purpose and explicit interfaces.
- Keep framework concerns, application logic, domain policies, and infrastructure separate.
- Treat Prisma as infrastructure. Repositories and adapters own persistence details.
- If the existing code leaks Prisma into controllers or collapses use-cases into large services, call that out and propose the smallest correction that improves the current work.
- Stay focused on the requested goal. Do not propose unrelated refactors.

## After the Design

### Documentation

- Write the validated spec to `docs/plans/YYYY-MM-DD-<topic>-design.md`
- Do not leave placeholder sections or vague architecture prose

### Spec Self-Review

After writing the spec, check:

1. **Placeholder scan:** no `TBD`, `TODO`, or vague requirements
2. **Internal consistency:** architecture, requirements, and test strategy do not contradict each other
3. **Scope check:** the work still fits one implementation plan
4. **Ambiguity check:** requirements cannot be interpreted in multiple incompatible ways
5. **Boundary check:** controller, application, domain, and infrastructure concerns are separated
6. **Prisma check:** Prisma is confined to repository or adapter boundaries

Fix issues inline before asking the user to review.

### User Review Gate

After the self-review loop passes, ask the user to review the written spec before proceeding:

> "Spec written to `<path>`. Review it and tell me if you want any changes before I write the implementation plan."

Wait for approval. If the user requests changes, update the spec and re-run the self-review loop.

## Key Principles

- **One question at a time**
- **Multiple choice preferred when it improves precision**
- **YAGNI ruthlessly**
- **Explore alternatives before committing**
- **Incremental validation**
- **NestJS-first for backend work**
- **Clean boundaries over convenience**
- **Prisma discipline**
- **SOLID over short-lived hacks**

## Transition

When the design is approved, the ONLY next skill is `nestjs-plan`.
