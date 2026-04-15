# Fullstack Think Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `fullstack-think` skill for mixed frontend and backend requests, keep `nuxt-think` and `nestjs-think` specialized, and route fullstack planning through parallel `nuxt-plan` and `nestjs-plan` generation with reconciliation guidance.

**Architecture:** The change is documentation-driven and test-first. Add one new skill file, update the existing think entry points so they redirect mixed work to `fullstack-think`, then align the feature-development entrypoints and README with the new orchestration model. Verify the behavior through the existing plugin tree and manifest tests before running the full suite.

**Tech Stack:** Markdown skill files, repository command docs, Codex skill mirrors, Node.js built-in test runner (`node --test`)

---

## File Map

| Path | Action | Responsibility |
| --- | --- | --- |
| `plugins/nimbou-skills/skills/fullstack-think/SKILL.md` | Create | Define the fullstack orchestration flow, shared specification gate, parallel plan dispatch, and reconciliation rules |
| `plugins/nimbou-skills/skills/nuxt-think/SKILL.md` | Modify | Redirect mixed frontend+backend requests to `fullstack-think` without weakening the Nuxt-specific workflow |
| `plugins/nimbou-skills/skills/nestjs-think/SKILL.md` | Modify | Redirect mixed requests to `fullstack-think` while keeping backend-first design rules intact |
| `plugins/nimbou-skills/commands/feature-dev.md` | Modify | Route fullstack features through `fullstack-think` instead of chaining `nestjs-think` and `nuxt-think` manually |
| `.codex/skills/feature-dev/SKILL.md` | Modify | Mirror the updated fullstack routing for Codex users |
| `README.md` | Modify | Document `fullstack-think` as the mixed-request entry point and explain how it relates to `nuxt-think` and `nestjs-think` |
| `tests/plugin/skill-tree.test.mjs` | Modify | Assert the new skill is shipped and documented in the expected orchestration surfaces |
| `tests/plugin/plugin-manifest.test.mjs` | Modify | Assert the new skill content, cross-references, and docs/command updates |

## Task 1: Add the shipped-skill and orchestrator contract tests

**Files:**
- Create: `plugins/nimbou-skills/skills/fullstack-think/SKILL.md`
- Modify: `tests/plugin/skill-tree.test.mjs`
- Modify: `tests/plugin/plugin-manifest.test.mjs`
- Test: `tests/plugin/skill-tree.test.mjs`
- Test: `tests/plugin/plugin-manifest.test.mjs`

- [ ] **Step 1: Write the failing tests for the new skill**

```js
// tests/plugin/skill-tree.test.mjs
assert.ok(shippedSkills.includes('fullstack-think'))

const files = [
  'plugins/nimbou-skills/skills/mapping-domain-states/SKILL.md',
  'plugins/nimbou-skills/skills/generating-gherkin-specs/SKILL.md',
  'plugins/nimbou-skills/skills/nuxt-think/SKILL.md',
  'plugins/nimbou-skills/skills/nestjs-think/SKILL.md',
  'plugins/nimbou-skills/skills/fullstack-think/SKILL.md',
]

const fullstackThink = read('plugins/nimbou-skills/skills/fullstack-think/SKILL.md')
assert.match(fullstackThink, /^---\nname: fullstack-think/m)
assert.match(fullstackThink, /mixed frontend and backend requests/i)
assert.match(fullstackThink, /use `mapping-domain-states`/i)
assert.match(fullstackThink, /use `generating-gherkin-specs`/i)
assert.match(fullstackThink, /`nuxt-plan` and `nestjs-plan` in parallel/i)
assert.match(fullstackThink, /reconcile/i)

// tests/plugin/plugin-manifest.test.mjs
const fullstackThink = read('plugins/nimbou-skills/skills/fullstack-think/SKILL.md')
assert.match(fullstackThink, /^---\nname: fullstack-think/m)
assert.match(fullstackThink, /dispatch `nuxt-plan` and `nestjs-plan` in parallel/i)
assert.match(fullstackThink, /reconcile/i)
```

- [ ] **Step 2: Run the targeted tests to prove the new skill is missing**

Run: `node --test tests/plugin/skill-tree.test.mjs tests/plugin/plugin-manifest.test.mjs`

Expected: FAIL with at least one missing-skill assertion such as `shippedSkills.includes('fullstack-think')` or a missing-file error for `plugins/nimbou-skills/skills/fullstack-think/SKILL.md`.

- [ ] **Step 3: Create the minimal `fullstack-think` skill**

```md
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
```

- [ ] **Step 4: Re-run the targeted tests to verify the new scaffold satisfies the new assertions**

Run: `node --test tests/plugin/skill-tree.test.mjs tests/plugin/plugin-manifest.test.mjs`

Expected: PASS for the new fullstack-think assertions, with any remaining failures limited to references that still need to be updated in later tasks.

- [ ] **Step 5: Commit the new skill scaffold and test coverage**

```bash
git add \
  plugins/nimbou-skills/skills/fullstack-think/SKILL.md \
  tests/plugin/skill-tree.test.mjs \
  tests/plugin/plugin-manifest.test.mjs
git commit -m "feat: add fullstack think scaffold"
```

### Task 2: Redirect mixed requests from the platform-specific think skills

**Files:**
- Modify: `plugins/nimbou-skills/skills/nuxt-think/SKILL.md`
- Modify: `plugins/nimbou-skills/skills/nestjs-think/SKILL.md`
- Modify: `tests/plugin/plugin-manifest.test.mjs`
- Test: `tests/plugin/plugin-manifest.test.mjs`

- [ ] **Step 1: Add failing assertions for the new cross-references**

```js
const nuxtThink = read('plugins/nimbou-skills/skills/nuxt-think/SKILL.md')
const nestjsThink = read('plugins/nimbou-skills/skills/nestjs-think/SKILL.md')

assert.match(nuxtThink, /use `fullstack-think` when the request changes both frontend and backend/i)
assert.match(nestjsThink, /use `fullstack-think` when the request changes both frontend and backend/i)
```

- [ ] **Step 2: Run the manifest test and verify the cross-references are not there yet**

Run: `node --test tests/plugin/plugin-manifest.test.mjs`

Expected: FAIL on the new `fullstack-think` redirect assertions for one or both files.

- [ ] **Step 3: Update the Nuxt and NestJS think skill intros**

```md
// plugins/nimbou-skills/skills/nuxt-think/SKILL.md
Use this skill instead of `nestjs-think` when the request is clearly Nuxt/Vuetify-first.
Use `fullstack-think` when the request changes both frontend and backend or depends on a new backend contract.

// plugins/nimbou-skills/skills/nestjs-think/SKILL.md
When the request is clearly frontend-first for Nuxt/Vuetify, use `nuxt-think` instead of forcing this workflow.
Use `fullstack-think` when the request changes both frontend and backend or when the frontend depends on a new backend contract.
```

- [ ] **Step 4: Re-run the manifest test to confirm the redirects are documented**

Run: `node --test tests/plugin/plugin-manifest.test.mjs`

Expected: PASS for the new redirect assertions, with any remaining failures limited to command or README updates from later tasks.

- [ ] **Step 5: Commit the cross-reference update**

```bash
git add \
  plugins/nimbou-skills/skills/nuxt-think/SKILL.md \
  plugins/nimbou-skills/skills/nestjs-think/SKILL.md \
  tests/plugin/plugin-manifest.test.mjs
git commit -m "docs: route mixed requests to fullstack think"
```

### Task 3: Route `/feature-dev` and the Codex mirror through `fullstack-think`

**Files:**
- Modify: `plugins/nimbou-skills/commands/feature-dev.md`
- Modify: `.codex/skills/feature-dev/SKILL.md`
- Modify: `tests/plugin/skill-tree.test.mjs`
- Test: `tests/plugin/skill-tree.test.mjs`

- [ ] **Step 1: Add failing assertions for the fullstack route**

```js
const featureCommand = read('plugins/nimbou-skills/commands/feature-dev.md')
const featureSkill = read('.codex/skills/feature-dev/SKILL.md')

assert.match(featureCommand, /fullstack-think/)
assert.match(featureCommand, /fullstack: `fullstack-think`, then `nuxt-plan` and `nestjs-plan` in parallel/i)
assert.match(featureCommand, /do not dispatch planning until the shared contract is closed/i)

assert.match(featureSkill, /fullstack-think/)
assert.match(featureSkill, /fullstack: `fullstack-think`, then `nuxt-plan` and `nestjs-plan` in parallel/i)
```

- [ ] **Step 2: Run the feature-workflow test and confirm the old routing fails**

Run: `node --test tests/plugin/skill-tree.test.mjs`

Expected: FAIL on one or more new `feature-dev` fullstack route assertions because the command and mirror still route fullstack work through both think skills directly.

- [ ] **Step 3: Update both feature-dev surfaces**

```md
// plugins/nimbou-skills/commands/feature-dev.md
- fullstack: `fullstack-think`, then `nuxt-plan` and `nestjs-plan` in parallel after the shared contract is approved
- do not dispatch planning until the shared contract is closed by `fullstack-think`
- do not start `nuxt-plan` or `nestjs-plan` from partial fullstack discovery

// .codex/skills/feature-dev/SKILL.md
- fullstack: `fullstack-think`, then `nuxt-plan` and `nestjs-plan` in parallel after the shared contract is approved
- do not dispatch planning until the shared contract is closed by `fullstack-think`
```

- [ ] **Step 4: Re-run the feature-workflow test**

Run: `node --test tests/plugin/skill-tree.test.mjs`

Expected: PASS for the command and Codex mirror assertions about the new fullstack route.

- [ ] **Step 5: Commit the feature-dev routing update**

```bash
git add \
  plugins/nimbou-skills/commands/feature-dev.md \
  .codex/skills/feature-dev/SKILL.md \
  tests/plugin/skill-tree.test.mjs
git commit -m "docs: route feature dev fullstack flow through fullstack think"
```

### Task 4: Document `fullstack-think` in the README

**Files:**
- Modify: `README.md`
- Modify: `tests/plugin/plugin-manifest.test.mjs`
- Test: `tests/plugin/plugin-manifest.test.mjs`

- [ ] **Step 1: Add the failing README assertions**

```js
const readme = readFileSync(resolve(root, 'README.md'), 'utf8')

assert.match(readme, /fullstack-think/)
assert.match(readme, /mixed-request entry point/i)
assert.match(readme, /frontend-only requests stay in `nuxt-think`/i)
assert.match(readme, /backend-only requests stay in `nestjs-think`/i)
```

- [ ] **Step 2: Run the README-focused test and verify it fails**

Run: `node --test tests/plugin/plugin-manifest.test.mjs`

Expected: FAIL on one or more new README assertions because the documentation does not mention `fullstack-think` yet.

- [ ] **Step 3: Update the README skill model and notes**

```md
### Core workflow skills

- `fullstack-think`
- `nestjs-think`
- `nestjs-plan`
- `executing-plans`

## Notes

- `fullstack-think` is the mixed-request entry point. Frontend-only requests stay in `nuxt-think`; backend-only requests stay in `nestjs-think`.
- `fullstack-think` closes shared specification first, then lets `nuxt-plan` and `nestjs-plan` run in parallel and reconciles the result before execution.
```

- [ ] **Step 4: Re-run the manifest test**

Run: `node --test tests/plugin/plugin-manifest.test.mjs`

Expected: PASS for the README assertions and the previously added fullstack-think documentation assertions.

- [ ] **Step 5: Commit the README update**

```bash
git add README.md tests/plugin/plugin-manifest.test.mjs
git commit -m "docs: add fullstack think to workflow docs"
```

### Task 5: Verify the integrated workflow

**Files:**
- Test: `tests/plugin/skill-tree.test.mjs`
- Test: `tests/plugin/plugin-manifest.test.mjs`
- Test: repository root suite via `npm test`

- [ ] **Step 1: Run the focused plugin tests together**

Run: `node --test tests/plugin/skill-tree.test.mjs tests/plugin/plugin-manifest.test.mjs`

Expected: PASS with the new fullstack-think assertions, updated think redirects, aligned `/feature-dev` routing, and README coverage.

- [ ] **Step 2: Run the full repository test suite**

Run: `npm test`

Expected: PASS with the catalog tests and plugin tests all green.

- [ ] **Step 3: Commit the final verified integration state if additional fixes were needed during verification**

```bash
git add \
  plugins/nimbou-skills/skills/fullstack-think/SKILL.md \
  plugins/nimbou-skills/skills/nuxt-think/SKILL.md \
  plugins/nimbou-skills/skills/nestjs-think/SKILL.md \
  plugins/nimbou-skills/commands/feature-dev.md \
  .codex/skills/feature-dev/SKILL.md \
  README.md \
  tests/plugin/skill-tree.test.mjs \
  tests/plugin/plugin-manifest.test.mjs
git commit -m "feat: add fullstack think orchestration"
```

## Self-Review

- **Spec coverage:** the tasks cover the new skill, the existing think-skill redirects, the fullstack feature-dev route, the Codex mirror, README documentation, and verification.
- **Placeholder scan:** no task uses `TODO`, `as needed`, or vague validation language; every code-editing step includes exact file paths and concrete content to add or replace.
- **Type consistency:** the same skill names are used throughout the plan: `fullstack-think`, `nuxt-think`, `nestjs-think`, `nuxt-plan`, and `nestjs-plan`.
