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
  assert.match(plan, /## Grupos de Execucao/)
  assert.match(plan, /wait for user approval/i)
  assert.match(plan, /executing-plans/)
})

test('core and audit skills document their new guardrails', () => {
  const files = [
    'skills/brainstorming/SKILL.md',
    'skills/writing-plans/SKILL.md',
    'skills/executing-plans/SKILL.md',
    'skills/nestjs-audit-http-tests/SKILL.md',
    'skills/nestjs-audit-prisma-repositories/SKILL.md',
    'skills/nuxt-audit/SKILL.md',
    'skills/nuxt-audit/reference/quality-rules.md',
    'skills/nuxt-test/SKILL.md',
    'skills/nuxt-test/reference/test-conventions.md',
  ]

  for (const file of files) {
    assert.equal(existsSync(resolve(root, file)), true, `${file} should exist`)
  }

  const brainstorming = read('skills/brainstorming/SKILL.md')
  const writingPlans = read('skills/writing-plans/SKILL.md')
  const execute = read('skills/executing-plans/SKILL.md')
  const nestHttpAudit = read('skills/nestjs-audit-http-tests/SKILL.md')
  const prismaAudit = read('skills/nestjs-audit-prisma-repositories/SKILL.md')
  const nuxtAudit = read('skills/nuxt-audit/SKILL.md')
  const qualityRules = read('skills/nuxt-audit/reference/quality-rules.md')
  const testSkill = read('skills/nuxt-test/SKILL.md')
  const testRules = read('skills/nuxt-test/reference/test-conventions.md')

  assert.match(brainstorming, /NestJS/)
  assert.match(brainstorming, /Prisma/)
  assert.match(brainstorming, /Clean Architecture/)
  assert.match(writingPlans, /repository contracts/i)
  assert.match(writingPlans, /Prisma adapters/i)
  assert.match(execute, /Group mode/)
  assert.match(execute, /parallel/)
  assert.match(nestHttpAudit, /^---\nname: nestjs-audit-http-tests/m)
  assert.match(prismaAudit, /^---\nname: nestjs-audit-prisma-repositories/m)
  assert.match(nuxtAudit, /Critico/)
  assert.match(qualityRules, /Vuetify/)
  assert.match(testSkill, /data-testid/)
  assert.match(testRules, /getByTestId/)
})
