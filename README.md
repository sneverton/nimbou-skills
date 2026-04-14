# nestjs-skills

`nestjs-skills` is a unified skill library for `Claude Code` and `Codex`. It keeps a backend-first workflow for `NestJS`, `Prisma`, `Clean Architecture`, and `SOLID`, while also shipping a prefixed Nuxt/Vuetify skill set for frontend-specific work.

This repository is no longer an upstream mirror. It is the canonical plugin that now consolidates:
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

- `skills/` contains the unified skill library exposed to Claude and Codex
- `agents/` contains auxiliary review and auditing agents
- `commands/` contains Claude command entrypoints such as `/feature-dev` and `/merge-pr`
- `.claude-plugin/` exposes the skill library to Claude Code
- `.codex/INSTALL.md` documents the Codex setup path
- `skills/nuxt-audit/reference/guidelines-template.md` is the template for project- or feature-level `GUIDELINES.md` files used by Nuxt planning and audit flows
- `docs/plans/` is the default location for generated plans and design artifacts
- `scripts/generate-catalog.ts` provides the fallback Nuxt component catalog generator
- `tests/` covers manifests, skill tree layout, and the catalog generator

## Codex Setup

Clone your fork and expose the skills through Codex native discovery:

```bash
git clone <your-fork-url> ~/.codex/nestjs-skills
mkdir -p ~/.agents/skills
ln -s ~/.codex/nestjs-skills/skills ~/.agents/skills/nestjs-skills
```

Then restart Codex.

## Claude Code Setup

This repository keeps the files needed for a local Claude plugin workflow:

- `.claude-plugin/plugin.json`
- `commands/feature-dev.md`
- `commands/merge-pr.md`

Point your Claude local plugin setup at this repository. The plugin manifest exposes `./skills` directly, without bootstrap hooks.

## Nuxt Catalog Workflow

The Nuxt domain ships a local catalog workflow:

```bash
npm install
npm run catalog
npm run catalog:validate
```

This fallback workflow writes:
- `components.meta.json`
- `.generated/component-catalog/components.meta.json`

If a target Nuxt project already has native catalog commands, the `nuxt-catalog` skill should prefer them.

## Notes

- `/feature-dev` provides a guided command workflow that classifies the request as backend-only, frontend-only, or fullstack and then uses `nestjs-think`, `nestjs-plan`, `nuxt-think`, `nuxt-plan`, `code-explorer`, `code-architect`, and `code-reviewer`.
- `/merge-pr` handles single-PR and batch merge flows, showing the effective PR state first and offering immediate merge or auto-merge.
- `nestjs-think` and `nestjs-plan` are intentionally backend-first. For Nuxt ideation and planning, use `nuxt-think` and `nuxt-plan`.
- `nestjs-debug` is the backend-first debugging flow for NestJS, Prisma, and boundary failures across controller, use-case, repository, and transaction layers.
- `nuxt-debug` is the frontend-first debugging flow for Nuxt/Vuetify browser issues using DevTools MCP and/or Playwright evidence before fixes.
- `nuxt-think` and `nuxt-audit` should resolve the nearest `GUIDELINES.md` for the feature area before closing design or review decisions.
- `nuxt-audit` is the single review pass for frontend architecture, extraction, hardening, performance, and polish; those concerns are not split into separate Nuxt skills here.
- `executing-plans` absorbs the former Nuxt dependency-aware execution pattern and can follow explicit execution groups.
- This fork intentionally removed upstream bootstrap hooks and unsupported harness integrations.

## License

MIT License. See `LICENSE`.
