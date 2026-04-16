# Codex Distribution Improvement Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Codex installation marketplace-only, require a Codex build with marketplace support, and keep the Claude marketplace flow intact.

**Architecture:** Treat `plugins/nimbou-skills` as the shared plugin root for both harnesses. Claude keeps using the existing marketplace path, while Codex gets a repo-scoped marketplace manifest plus a Codex plugin manifest for marketplace-based discovery. Bootstrap logic becomes strict: if the installed Codex CLI cannot register marketplaces, the script stops and tells the user to upgrade to the recommended Codex release before rerunning the bootstrap.

**Tech Stack:** Bash bootstrap, JSON manifests, Markdown docs, Node.js built-in test runner (`node --test`)

---

## File Map

| Path | Action | Responsibility |
| --- | --- | --- |
| `plugins/nimbou-skills/.codex-plugin/plugin.json` | Create | Codex plugin manifest that points at the shared skill tree |
| `.agents/plugins/marketplace.json` | Create | Repo-scoped Codex marketplace catalog for the local plugin |
| `install.sh` | Modify | Register the Codex marketplace only when supported, otherwise exit with an upgrade instruction, and keep Claude installation behavior intact |
| `README.md` | Modify | Document the Codex marketplace path, the required Codex version, and the current installation flow |
| `tests/plugin/plugin-manifest.test.mjs` | Modify | Assert the new Codex manifest and marketplace metadata exist and are documented |
| `tests/plugin/skill-tree.test.mjs` | Modify | Assert the shared plugin root still ships the expected skills and supporting manifests |

## Task 1: Add Codex packaging metadata

**Files:**
- Create: `plugins/nimbou-skills/.codex-plugin/plugin.json`
- Create: `.agents/plugins/marketplace.json`
- Test: `tests/plugin/plugin-manifest.test.mjs`

- [ ] **Step 1: Add failing assertions for the Codex manifests**

```js
assert.equal(existsSync(resolve(root, 'plugins/nimbou-skills/.codex-plugin/plugin.json')), true)
assert.equal(existsSync(resolve(root, '.agents/plugins/marketplace.json')), true)
```

- [ ] **Step 2: Run the targeted manifest test and confirm the files are missing**

Run: `node --test tests/plugin/plugin-manifest.test.mjs`

Expected: FAIL with missing-file assertions for the new Codex manifests.

- [ ] **Step 3: Create the minimal Codex plugin manifest and marketplace**

```json
// plugins/nimbou-skills/.codex-plugin/plugin.json
{
  "name": "nimbou-skills",
  "version": "0.2.0",
  "description": "Unified Claude Code skill library with NestJS backend core and Nuxt/Vuetify frontend skills",
  "skills": "./skills/"
}

// .agents/plugins/marketplace.json
{
  "name": "nimbou-skills",
  "interface": {
    "displayName": "nimbou-skills"
  },
  "plugins": [
    {
      "name": "nimbou-skills",
      "source": {
        "source": "local",
        "path": "./plugins/nimbou-skills"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Productivity"
    }
  ]
}
```

- [ ] **Step 4: Re-run the manifest test and verify the new metadata is present**

Run: `node --test tests/plugin/plugin-manifest.test.mjs`

Expected: PASS for the Codex manifest existence checks.

## Task 2: Update the bootstrap to register Codex when supported

**Files:**
- Modify: `install.sh`
- Test: `tests/plugin/plugin-manifest.test.mjs`

- [ ] **Step 1: Add failing assertions for the Codex bootstrap behavior**

```js
assert.match(install, /codex marketplace/i)
assert.match(install, /\.agents\/plugins\/marketplace\.json/)
assert.match(install, /Codex marketplace/)
assert.match(install, /Install Codex rust-v0\.121\.0\+ or newer/)
assert.doesNotMatch(install, /link_skill_tree/)
```

- [ ] **Step 2: Replace the fallback path with a hard requirement**

```bash
if ! command -v codex >/dev/null 2>&1; then
  echo "Codex CLI not found. Install Codex rust-v0.121.0+ or newer, then rerun install.sh." >&2
  exit 1
fi

if ! codex help 2>/dev/null | grep -q 'marketplace'; then
  echo "Codex marketplace support is required. Install Codex rust-v0.121.0+ or newer, then rerun install.sh." >&2
  exit 1
fi

codex marketplace add "$CODEX_MARKETPLACE_FILE" \
  && echo "Codex marketplace added: $CODEX_MARKETPLACE_FILE" \
  || {
    echo "Failed to register the Codex marketplace. Install Codex rust-v0.121.0+ or newer and rerun install.sh." >&2
    exit 1
  }
```

- [ ] **Step 3: Re-run the manifest test**

Run: `node --test tests/plugin/plugin-manifest.test.mjs`

Expected: PASS once the bootstrap requires marketplace support and the upgrade guidance is documented.

## Task 3: Document the distribution path

**Files:**
- Modify: `README.md`
- Test: `tests/plugin/plugin-manifest.test.mjs`

- [ ] **Step 1: Add failing README assertions**

```js
assert.match(readme, /Codex marketplace/i)
assert.match(readme, /\.agents\/plugins\/marketplace\.json/)
assert.match(readme, /Codex rust-v0\.121\.0\+ or newer/i)
assert.doesNotMatch(readme, /local skill-tree fallback/i)
```

- [ ] **Step 2: Update the installation section**

```md
The bootstrap script:
- registers and installs the Claude Code plugin
- requires Codex rust-v0.121.0+ or newer for marketplace installation
- registers the Codex marketplace from `.agents/plugins/marketplace.json`
- runs `npm link` for `nb-catalog`
```

- [ ] **Step 3: Re-run the manifest test**

Run: `node --test tests/plugin/plugin-manifest.test.mjs`

Expected: PASS for the new README assertions.

## Task 4: Verify the final diff

**Files:**
- Test: `tests/plugin/plugin-manifest.test.mjs`
- Test: `tests/plugin/skill-tree.test.mjs`

- [ ] **Step 1: Run the focused plugin tests**

Run: `node --test tests/plugin/plugin-manifest.test.mjs tests/plugin/skill-tree.test.mjs`

Expected: PASS.

- [ ] **Step 2: Inspect the final git diff**

Run: `git --no-pager diff -- install.sh README.md plugins/nimbou-skills/.codex-plugin/plugin.json .agents/plugins/marketplace.json tests/plugin/plugin-manifest.test.mjs tests/plugin/skill-tree.test.mjs`

Expected: The diff shows only the Codex distribution metadata, bootstrap, docs, and test coverage described above.
