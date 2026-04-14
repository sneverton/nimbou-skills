import test from 'node:test'
import assert from 'node:assert/strict'
import { existsSync, readFileSync, readdirSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..')

function readJson(relativePath) {
  return JSON.parse(readFileSync(resolve(root, relativePath), 'utf8'))
}

test('plugin manifest points to the unified skills tree', () => {
  const plugin = readJson('.claude-plugin/plugin.json')
  const skillsRoot = resolve(root, plugin.skills)
  const shippedSkills = readdirSync(skillsRoot, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name)
    .sort()

  assert.equal(plugin.name, 'nestjs-skills')
  assert.equal(plugin.skills, './skills')
  assert.equal(existsSync(skillsRoot), true)
  assert.ok(shippedSkills.includes('nestjs-think'))
  assert.ok(shippedSkills.includes('nestjs-plan'))
  assert.ok(shippedSkills.includes('executing-plans'))
  assert.ok(shippedSkills.includes('nuxt-think'))
  assert.ok(shippedSkills.includes('nuxt-plan'))
  assert.ok(shippedSkills.includes('nuxt-catalog'))
  assert.ok(shippedSkills.includes('nuxt-audit'))
  assert.ok(shippedSkills.includes('nuxt-test'))
  assert.ok(shippedSkills.includes('nestjs-audit-http-tests'))
  assert.ok(shippedSkills.includes('nestjs-audit-prisma-repositories'))

  for (const skillName of shippedSkills) {
    const skillFile = resolve(skillsRoot, skillName, 'SKILL.md')
    assert.equal(existsSync(skillFile), true, `Missing scaffold file: ${skillFile}`)
    assert.match(readFileSync(skillFile, 'utf8'), /^---\nname: /, `Missing frontmatter in ${skillFile}`)
  }
})

test('marketplace manifest points at the local unified plugin folder', () => {
  const marketplace = readJson('.claude-plugin/marketplace.json')
  const pluginEntry = marketplace.plugins[0]

  assert.equal(marketplace.name, 'nestjs-skills-dev')
  assert.equal(marketplace.$schema, 'https://anthropic.com/claude-code/marketplace.schema.json')
  assert.equal(pluginEntry.source, './')
  assert.equal(pluginEntry.name, 'nestjs-skills')
})

test('README documents backend-first core and prefixed NestJS and Nuxt skills', () => {
  const readme = readFileSync(resolve(root, 'README.md'), 'utf8')

  assert.match(readme, /backend-first/i)
  assert.match(readme, /NestJS/)
  assert.match(readme, /Prisma/)
  assert.match(readme, /nestjs-think/)
  assert.match(readme, /nestjs-plan/)
  assert.match(readme, /nuxt-think/)
  assert.match(readme, /nuxt-plan/)
  assert.match(readme, /nuxt-catalog/)
  assert.match(readme, /nuxt-audit/)
  assert.match(readme, /nuxt-test/)
  assert.match(readme, /nestjs-audit-http-tests/)
  assert.match(readme, /nestjs-audit-prisma-repositories/)
  assert.match(readme, /\.generated\/component-catalog\/components\.meta\.json/)
  assert.equal(existsSync(resolve(root, 'LICENSE')), true)
})
