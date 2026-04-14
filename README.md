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
- `systematic-debugging`
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

## Repository Layout

- `skills/` contains the unified skill library exposed to Claude and Codex
- `agents/` contains auxiliary review and auditing agents
- `.claude-plugin/` exposes the skill library to Claude Code
- `.codex/INSTALL.md` documents the Codex setup path
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

- `nestjs-think` and `nestjs-plan` are intentionally backend-first. For Nuxt ideation and planning, use `nuxt-think` and `nuxt-plan`.
- `executing-plans` absorbs the former Nuxt dependency-aware execution pattern and can follow explicit execution groups.
- This fork intentionally removed upstream bootstrap hooks and unsupported harness integrations.

## License

MIT License. See `LICENSE`.
