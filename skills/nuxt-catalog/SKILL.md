---
name: nuxt-catalog
description: Generate and validate the Nuxt component catalog for Vue SFCs with semantic and technical metadata.
---

# Nuxt Catalog

## Purpose

Scan `components/**/*.vue`, extract `<catalog lang="json">`, merge the result with `vue-component-meta`, and write both the rich `components.meta.json` catalog and the slim `.generated/component-catalog/components.meta.json` mirror.

## Execution Priority

1. If the project only ships catalog artifacts and the user wants to inspect or reuse them, read `components.meta.json` or `.generated/component-catalog/components.meta.json` directly.
2. Otherwise use the bundled workflow from this `nimbou-skills` checkout as the default path. Do not require `catalog:validate` or `catalog:generate` to exist inside the target project.
3. Use project-native catalog scripts only when the user explicitly asks for the project's own generator or when the target project requires behavior that this bundled generator cannot provide.
4. If the machine has this repository linked globally with `pnpm link --global`, prefer the `catalog` CLI for human-triggered execution.

## Behavior

1. Read the project root catalog target from the current working directory.
2. Resolve the `nimbou-skills` repo root that contains `package.json` and `skills/nuxt-catalog/scripts/generate-catalog.ts`.
3. Run the bundled scripts against the target project by setting `CATALOG_ROOT` to the target root and using `npm --prefix <nimbou-skills-root> run ...`.
   - if the global bin is installed, `catalog validate` and `catalog generate` are equivalent wrappers
4. Default flow is `validate -> generate`:
   - run validation first
   - only run generation if validation passes
   - stop after validation when the user asked only for audit or troubleshooting
5. Inspect every Vue component under `components/` only in fallback mode.
6. Require the semantic schema documented in `reference/catalog-schema.md`.
7. Validate `category` and `domain` rules from `reference/taxonomy.md`.
8. Report broken `related`, `replaces`, and `usedBy` references in the rich schema.
9. In the bundled workflow, generate `components.meta.json`, `.generated/component-catalog/components.meta.json`, and `components/{ComponentName}.meta.json` only after validation passes.
10. If the user only wants catalog consultation, reuse, or planning context, read the existing artifacts instead of regenerating them.

## Embedded Skill Setup

If the user wants this skill copied into a project instead of executed from the shared `nimbou-skills` checkout:

1. Copy `skills/nuxt-catalog/` into the target project as `.claude/skills/nuxt-catalog/`
2. Run `.claude/skills/nuxt-catalog/scripts/install.sh <project-root>`
3. Use the local project scripts after bootstrap:
   - `npm run catalog:validate`
   - `npm run catalog`

Do not ask the user to install `tsx` globally. The bootstrap script installs all local dependencies required by the generator and can add the package scripts automatically.

## Typical invocations

- Bundled workflow against the target project:
  - `CATALOG_ROOT="$PWD" npm --prefix <nimbou-skills-root> run catalog:validate`
  - `CATALOG_ROOT="$PWD" npm --prefix <nimbou-skills-root> run catalog`
- Global linked CLI on a machine that ran `pnpm link --global` from this repo:
  - `catalog validate`
  - `catalog generate`
  - `catalog generate projects`
- If the user explicitly wants the target project's own generator:
  - `pnpm catalog:validate`
  - `pnpm catalog:generate`
- If the skill was embedded into the target project:
  - `.claude/skills/nuxt-catalog/scripts/install.sh "$PWD"`
  - `npm run catalog:validate`
  - `npm run catalog`
