# nimbou-skills

`nimbou-skills` is a unified skill library for `Claude Code` and `Codex`. It keeps a backend-first workflow for `NestJS`, `Prisma`, `Clean Architecture`, and `SOLID`, while also shipping a prefixed Nuxt/Vuetify skill set for frontend-specific work and Codex-only skill mirrors for Claude command entrypoints under `.codex/skills/`.

This repository is no longer an upstream mirror. It is the canonical repository that now consolidates:
- a backend-first workflow core
- NestJS-specific auditing skills
- Nuxt/Vuetify-specific prefixed skills
- shared Claude and Codex integration files

## Skill Model

- Supported harnesses: `Claude Code` and `Codex`
- Default architecture bias: `NestJS + Prisma + Clean Architecture + SOLID`
- NestJS-specific planning and auditing work stays explicit through `nestjs-*` skill names
- Nuxt-specific work stays explicit through `nuxt-*` skill names

### Core workflow skills

- `nestjs-think`
- `nestjs-plan`
- `executing-plans`
- `subagent-driven-development`
- `dispatching-parallel-agents`
- `test-driven-development`
- `e2e-test-quality`
- `nestjs-debug` backend-first debugging for NestJS/Prisma work
- `verification-before-completion`
- `requesting-code-review`
- `receiving-code-review`
- `using-git-worktrees`
- `finishing-a-development-branch`
- `writing-skills`

### NestJS-specific skills

- `nestjs-audit-http-tests`
- `nestjs-audit-prisma-repositories`

### Nuxt-specific skills

- `nuxt-think`
- `nuxt-plan`
- `nuxt-catalog`
- `nuxt-audit`
- `nuxt-test`
- `nuxt-debug`

## Repository Layout

- `plugins/nimbou-skills/` is the Claude Code plugin containing all components:
  - `skills/` — the unified skill library
  - `agents/` — auxiliary review and auditing agents
    including `code-explorer`, `code-architect`, `code-reviewer`, `guidelines-gap-analyzer`, and `e2e-quality-auditor`
  - `commands/` — Claude command entrypoints such as `/feature-dev`, `/design-md`, and `/merge-pr`
  - `skills/nuxt-audit/reference/design-md-template.md` is the template for `DESIGN.MD` files
  - `skills/nuxt-catalog/scripts/generate-catalog.ts` provides the bundled Nuxt component catalog generator
- `.codex/skills/` — Codex-only mirrors for the Claude command workflows
- `.claude-plugin/marketplace.json` — marketplace manifest for `claude plugin marketplace add`
- `docs/plans/` is the default location for generated plans and design artifacts
- `tests/` covers the skill tree layout, install flow documentation, and the catalog generator

## Installation

Clone the repository once into `/var/www` and run the single bootstrap script:

```bash
cd /var/www
git clone <your-fork-url> nimbou-skills
cd /var/www/nimbou-skills
./install.sh
```

The bootstrap script does all required machine setup:
- runs `pnpm install`
- registers the GitHub repo as a Claude Code marketplace via `claude plugin marketplace add`
- installs the plugin via `claude plugin install`
- links skills into `~/.agents/skills/nimbou-skills` for Codex, including the Codex-only mirrors from `.codex/skills/`
- runs `npm link` to publish the `nb-catalog` CLI
- creates `~/.local/bin/codex-full` if it does not already exist, wired to `codex --dangerously-bypass-approvals-and-sandbox`

After the bootstrap finishes, restart Claude Code so it picks up the new plugin.

## Nuxt Catalog Workflow

The Nuxt domain ships a shared machine-level catalog workflow:

```bash
cd /path/to/project
nb-catalog validate
nb-catalog generate
```

Optional domain filtering stays available:

```bash
nb-catalog generate projects
```

This fallback workflow writes:
- `components.meta.json`
- `.generated/component-catalog/components.meta.json`

The `nuxt-catalog` skill should default to `validate -> generate` and runs the bundled generator from this repository against the current project via `CATALOG_ROOT`, without requiring catalog scripts in the target project.

If a project explicitly wants a copied local fallback instead of depending on `/var/www/nimbou-skills` at runtime, copy `skills/nuxt-catalog/` into `.claude/skills/nuxt-catalog/` and run `.claude/skills/nuxt-catalog/scripts/install.sh <project-root>`.

## Notes

- `/feature-dev` provides a guided command workflow that classifies the request as backend-only, frontend-only, or fullstack and then uses `nestjs-think`, `nestjs-plan`, `nuxt-think`, `nuxt-plan`, `code-explorer`, `code-architect`, and `code-reviewer`.
- `guidelines-gap-analyzer` is the conventions-first review agent for checking changed work against local `AGENTS.md`, `CLAUDE.md`, `GUIDELINES.md`, and `DESIGN.MD` files without hard-coding project-specific paths.
- `e2e-test-quality` dispatches `e2e-quality-auditor` for bounded browser-driven flows when the main question is E2E reliability, setup quality, selectors, waits, and whether the failure is in the test or the product.
- `/design-md` explores a target project or app, asks only the missing design questions, and creates or refreshes `DESIGN.MD` at the app root for monorepos or the repo root otherwise.
- `/merge-pr` handles single-PR and batch merge flows, showing the effective PR state first and offering immediate merge or auto-merge.
- `nestjs-think` and `nestjs-plan` are intentionally backend-first. For Nuxt ideation and planning, use `nuxt-think` and `nuxt-plan`.
- `nestjs-debug` is the backend-first debugging flow for NestJS, Prisma, and boundary failures across controller, use-case, repository, and transaction layers.
- `nuxt-debug` is the frontend-first debugging flow for Nuxt/Vuetify browser issues. In Codex it is Chrome DevTools MCP first, with Playwright only when scripted reproduction is required.
- `nuxt-test` is the narrower Playwright/E2E discipline for a bounded Nuxt/Vuetify module or user flow: selectors, waits, auth/setup drift, and coverage expansion.
- `nuxt-test` now prefers semantic selectors first and uses `data-testid` only when the UI does not expose a stable observable contract.
- `nuxt-debug` investigates live runtime behavior; `nuxt-test` codifies the result into trustworthy bounded coverage.
- use `e2e-test-quality` when the problem is broader end-to-end flow reliability or mixed setup/product failure analysis beyond one Nuxt module slice.
- `nuxt-think`, `nuxt-plan`, and `nuxt-audit` should resolve the nearest `DESIGN.MD` in the target project before closing design, planning, or review decisions.
- `nuxt-audit` is the single review pass for frontend architecture, extraction, hardening, performance, and polish; those concerns are not split into separate Nuxt skills here.
- `executing-plans` absorbs the former Nuxt dependency-aware execution pattern and can follow explicit execution groups.
- This fork intentionally removed upstream bootstrap hooks and unsupported harness integrations.

## License

MIT License. See `LICENSE`.
