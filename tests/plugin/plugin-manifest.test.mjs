import test from 'node:test'
import assert from 'node:assert/strict'
import { existsSync, readFileSync, readdirSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..')

test('skills tree ships the unified skill set directly', () => {
  const skillsRoot = resolve(root, 'plugins/nimbou-skills/skills')
  const shippedSkills = readdirSync(skillsRoot, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name)
    .sort()

  assert.equal(existsSync(skillsRoot), true)
  assert.ok(shippedSkills.includes('nestjs-think'))
  assert.ok(shippedSkills.includes('nestjs-plan'))
  assert.ok(shippedSkills.includes('executing-plans'))
  assert.ok(shippedSkills.includes('e2e-test-quality'))
  assert.ok(shippedSkills.includes('nuxt-think'))
  assert.ok(shippedSkills.includes('nuxt-plan'))
  assert.ok(shippedSkills.includes('nuxt-catalog'))
  assert.ok(shippedSkills.includes('nuxt-audit'))
  assert.ok(shippedSkills.includes('nuxt-test'))
  assert.ok(shippedSkills.includes('nestjs-debug'))
  assert.ok(shippedSkills.includes('nuxt-debug'))
  assert.ok(shippedSkills.includes('nestjs-audit-http-tests'))
  assert.ok(shippedSkills.includes('nestjs-audit-prisma-repositories'))

  for (const skillName of shippedSkills) {
    const skillFile = resolve(skillsRoot, skillName, 'SKILL.md')
    assert.equal(existsSync(skillFile), true, `Missing scaffold file: ${skillFile}`)
    assert.match(readFileSync(skillFile, 'utf8'), /^---\nname: /, `Missing frontmatter in ${skillFile}`)
  }

  assert.equal(existsSync(resolve(root, '.claude-plugin/marketplace.json')), true)
})

test('command and agent scaffolds exist for guided feature development', () => {
  const files = [
    'plugins/nimbou-skills/commands/feature-dev.md',
    'plugins/nimbou-skills/commands/design-md.md',
    'plugins/nimbou-skills/commands/merge-pr.md',
    '.codex/skills/feature-dev/SKILL.md',
    '.codex/skills/design-md/SKILL.md',
    '.codex/skills/merge-pr/SKILL.md',
    'plugins/nimbou-skills/agents/code-explorer.md',
    'plugins/nimbou-skills/agents/code-architect.md',
    'plugins/nimbou-skills/agents/code-reviewer.md',
    'plugins/nimbou-skills/agents/guidelines-gap-analyzer.md',
    'plugins/nimbou-skills/agents/e2e-quality-auditor.md',
    'plugins/nimbou-skills/skills/nuxt-audit/reference/design-md-template.md',
  ]

  for (const file of files) {
    assert.equal(existsSync(resolve(root, file)), true, `${file} should exist`)
  }
})

test('README documents backend-first core and prefixed NestJS and Nuxt skills', () => {
  const readme = readFileSync(resolve(root, 'README.md'), 'utf8')
  const install = readFileSync(resolve(root, 'install.sh'), 'utf8')

  assert.match(readme, /canonical skill library/i)
  assert.match(readme, /backend-first/i)
  assert.match(readme, /NestJS/)
  assert.match(readme, /Prisma/)
  assert.match(readme, /feature-dev/)
  assert.match(readme, /design-md/)
  assert.match(readme, /merge-pr/)
  assert.match(readme, /\.codex\/skills\//)
  assert.match(readme, /e2e-test-quality/)
  assert.match(readme, /nestjs-think/)
  assert.match(readme, /nestjs-plan/)
  assert.match(readme, /nuxt-think/)
  assert.match(readme, /nuxt-plan/)
  assert.match(readme, /nuxt-catalog/)
  assert.match(readme, /nuxt-audit/)
  assert.match(readme, /nuxt-test/)
  assert.match(readme, /nuxt-debug/)
  assert.match(readme, /\.\/install\.sh/)
  assert.match(readme, /~\/\.agents\/skills\/nimbou-skills/)
  assert.match(readme, /Codex-only mirrors/)
  assert.match(readme, /nb-catalog/)
  assert.match(readme, /single frontend review pass/i)
  assert.match(readme, /\.generated\/component-catalog\/components\.meta\.json/)
  assert.match(readme, /codex-full/)
  assert.match(readme, /dangerously-bypass-approvals-and-sandbox/)
  assert.match(readme, /registers and installs the Claude Code plugin/)
  assert.match(readme, /runs `npm link` for `nb-catalog`/)
  assert.match(install, /link_skill_tree/)
  assert.match(install, /\.codex\/skills/)
  assert.match(install, /CODEX_SKILL_ROOT/)
  assert.match(install, /setup-codex-full-wrapper\.sh/)
  assert.match(install, /CODEX_WRAPPER_PATH/)
  assert.equal(existsSync(resolve(root, 'LICENSE')), true)
})
