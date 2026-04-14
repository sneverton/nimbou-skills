import test from 'node:test'
import assert from 'node:assert/strict'
import { existsSync, readFileSync } from 'node:fs'
import { resolve } from 'node:path'

const root = resolve(import.meta.dirname, '..', '..')

function read(relativePath) {
  return readFileSync(resolve(root, relativePath), 'utf8')
}

test('nuxt catalog skill files exist and describe validate mode', () => {
  const files = [
    'skills/nuxt-catalog/SKILL.md',
    'skills/nuxt-catalog/reference/catalog-schema.md',
    'skills/nuxt-catalog/reference/taxonomy.md',
  ]

  for (const file of files) {
    assert.equal(existsSync(resolve(root, file)), true, `${file} should exist`)
  }

  const skill = read('skills/nuxt-catalog/SKILL.md')
  assert.match(skill, /\/catalog --validate/)
  assert.match(skill, /catalog:generate/)
  assert.match(skill, /catalog:validate/)
  assert.match(skill, /fallback/)
  assert.match(skill, /scripts\/generate-catalog\.ts/)
  assert.match(skill, /components\.meta\.json/)
  assert.match(skill, /\.generated\/component-catalog\/components\.meta\.json/)
})

test('nuxt think and plan skills explain catalog-aware design and execution topology', () => {
  const files = [
    'skills/nuxt-think/SKILL.md',
    'skills/nuxt-think/reference/conventions.md',
    'skills/nuxt-plan/SKILL.md',
    'skills/nuxt-plan/reference/plan-format.md',
    'skills/nuxt-audit/reference/guidelines-template.md',
  ]

  for (const file of files) {
    assert.equal(existsSync(resolve(root, file)), true, `${file} should exist`)
  }

  const think = read('skills/nuxt-think/SKILL.md')
  const plan = read('skills/nuxt-plan/SKILL.md')

  assert.match(think, /components\.meta\.json/)
  assert.match(think, /\.generated\/component-catalog\/components\.meta\.json/)
  assert.match(think, /tags`, `category`, and `domain/)
  assert.match(think, /## Think Output/)
  assert.match(think, /This skill owns discovery and design closure/i)
  assert.match(think, /nearest `GUIDELINES\.md`/i)
  assert.match(think, /loading, empty, error, and success states/i)
  assert.match(think, /responsive layout shifts/i)
  assert.match(think, /### Direcao visual/)
  assert.match(think, /anti-genericity guardrails/i)
  assert.match(think, /exact file paths, dependency order, and execution groups/i)
  assert.match(plan, /## Scope Check/)
  assert.match(plan, /## Minimal Clarifications Only/)
  assert.match(plan, /Assume `nuxt-think` already closed product and UI decisions\./)
  assert.match(plan, /exact route or page file path/i)
  assert.match(plan, /Do not reopen settled UX, reuse, state, interaction, or responsive decisions/i)
  assert.match(plan, /## Self-Review/)
  assert.match(plan, /## Grupos de Execucao/)
  assert.match(plan, /wait for user approval/i)
  assert.match(plan, /executing-plans/)
})

test('core and audit skills document their new guardrails', () => {
  const files = [
    'skills/nestjs-think/SKILL.md',
    'skills/nestjs-plan/SKILL.md',
    'skills/executing-plans/SKILL.md',
    'skills/nestjs-debug/SKILL.md',
    'skills/nestjs-audit-http-tests/SKILL.md',
    'skills/nestjs-audit-prisma-repositories/SKILL.md',
    'skills/nuxt-audit/SKILL.md',
    'skills/nuxt-audit/reference/quality-rules.md',
    'skills/nuxt-test/SKILL.md',
    'skills/nuxt-test/reference/test-conventions.md',
    'skills/nuxt-debug/SKILL.md',
  ]

  for (const file of files) {
    assert.equal(existsSync(resolve(root, file)), true, `${file} should exist`)
  }

  const nestjsThink = read('skills/nestjs-think/SKILL.md')
  const nestjsPlan = read('skills/nestjs-plan/SKILL.md')
  const execute = read('skills/executing-plans/SKILL.md')
  const systematic = read('skills/nestjs-debug/SKILL.md')
  const nestHttpAudit = read('skills/nestjs-audit-http-tests/SKILL.md')
  const prismaAudit = read('skills/nestjs-audit-prisma-repositories/SKILL.md')
  const nuxtAudit = read('skills/nuxt-audit/SKILL.md')
  const qualityRules = read('skills/nuxt-audit/reference/quality-rules.md')
  const testSkill = read('skills/nuxt-test/SKILL.md')
  const testRules = read('skills/nuxt-test/reference/test-conventions.md')
  const nuxtDebug = read('skills/nuxt-debug/SKILL.md')
  const guidelines = read('skills/nuxt-audit/reference/guidelines-template.md')
  assert.match(nestjsThink, /^---\nname: nestjs-think/m)
  assert.match(nestjsThink, /NestJS/)
  assert.match(nestjsThink, /Prisma/)
  assert.match(nestjsThink, /Clean Architecture/)
  assert.match(nestjsPlan, /^---\nname: nestjs-plan/m)
  assert.match(nestjsPlan, /repository contracts/i)
  assert.match(nestjsPlan, /Prisma adapters/i)
  assert.match(execute, /Group mode/)
  assert.match(execute, /parallel/)
  assert.match(execute, /nestjs-skills:nuxt-plan/)
  assert.match(execute, /group-driven frontend plans/i)
  assert.match(systematic, /^---\nname: nestjs-debug/m)
  assert.match(systematic, /NestJS/)
  assert.match(systematic, /Prisma/)
  assert.match(systematic, /Clean Architecture/)
  assert.match(systematic, /request, module, use-case, repository, Prisma flow/i)
  assert.match(nestHttpAudit, /^---\nname: nestjs-audit-http-tests/m)
  assert.match(prismaAudit, /^---\nname: nestjs-audit-prisma-repositories/m)
  assert.match(nuxtAudit, /^---\nname: nuxt-audit/m)
  assert.match(nuxtAudit, /single frontend review pass/i)
  assert.match(nuxtAudit, /nearest `GUIDELINES\.md`/i)
  assert.match(nuxtAudit, /Hardening/i)
  assert.match(nuxtAudit, /Performance/i)
  assert.match(nuxtAudit, /Polish/i)
  assert.match(nuxtAudit, /Do not split the review into separate "harden", "extract", "optimize", or "polish" passes/i)
  assert.match(nuxtAudit, /Critico/)
  assert.match(qualityRules, /Guideline First/)
  assert.match(qualityRules, /Extraction and Reuse/)
  assert.match(qualityRules, /Hardening/)
  assert.match(qualityRules, /Performance/)
  assert.match(qualityRules, /Polish/)
  assert.match(qualityRules, /Vuetify/)
  assert.match(testSkill, /data-testid/)
  assert.match(testRules, /getByTestId/)
  assert.match(nuxtDebug, /^---\nname: nuxt-debug/m)
  assert.match(nuxtDebug, /DevTools MCP/i)
  assert.match(nuxtDebug, /Playwright/)
  assert.match(nuxtDebug, /hydration/i)
  assert.match(nuxtDebug, /NO FRONTEND FIXES BEFORE LIVE BROWSER EVIDENCE/)
  assert.match(guidelines, /Nuxt Frontend Guidelines/)
  assert.match(guidelines, /Component Responsibility Model/)
  assert.match(guidelines, /Visual Guardrails/)
  assert.match(guidelines, /Hardening Expectations/)
  assert.match(guidelines, /Audit Expectations/)
})

test('feature development command and agents describe the guided orchestration workflow', () => {
  const featureCommand = read('commands/feature-dev.md')
  const mergeCommand = read('commands/merge-pr.md')
  const explorer = read('agents/code-explorer.md')
  const architect = read('agents/code-architect.md')
  const reviewer = read('agents/code-reviewer.md')

  assert.match(featureCommand, /^---\ndescription:/m)
  assert.match(featureCommand, /backend-only/)
  assert.match(featureCommand, /frontend-only/)
  assert.match(featureCommand, /fullstack/)
  assert.match(featureCommand, /nestjs-think/)
  assert.match(featureCommand, /nuxt-think/)
  assert.match(featureCommand, /code-explorer/)
  assert.match(featureCommand, /code-architect/)
  assert.match(featureCommand, /code-reviewer/)
  assert.match(featureCommand, /Phase 1: Discovery/)
  assert.match(featureCommand, /Phase 6: Quality Review/)

  assert.match(mergeCommand, /^---\ndescription:/m)
  assert.match(mergeCommand, /Single mode/)
  assert.match(mergeCommand, /Batch mode/)
  assert.match(mergeCommand, /Never merge without showing the effective PR state first/)
  assert.match(mergeCommand, /auto-merge/i)
  assert.match(mergeCommand, /gh pr merge/)
  assert.match(mergeCommand, /Type `merge` to continue/)
  assert.match(mergeCommand, /merged/)
  assert.match(mergeCommand, /auto-merge enabled/)
  assert.match(mergeCommand, /skipped/)
  assert.match(mergeCommand, /failed/)

  assert.match(explorer, /^---\nname: code-explorer/m)
  assert.match(explorer, /Key Files To Read/)
  assert.match(explorer, /path:line - why it matters/)

  assert.match(architect, /^---\nname: code-architect/m)
  assert.match(architect, /minimal changes/)
  assert.match(architect, /clean architecture/)
  assert.match(architect, /pragmatic balance/)

  assert.match(reviewer, /^---\nname: code-reviewer/m)
  assert.match(reviewer, /Only report issues with confidence `>= 80`/)
  assert.match(reviewer, /Optional Review Focus/)
  assert.match(reviewer, /Critical/)
  assert.match(reviewer, /Important/)
})
