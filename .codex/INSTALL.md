# Installing nimbou-skills for Codex

Enable the unified `nimbou-skills` plugin in Codex via native skill discovery.

## Prerequisites

- Git

## Installation

1. **Clone your fork:**
   ```bash
   git clone <your-fork-url> ~/.codex/nimbou-skills
   ```

2. **Create the skills symlink:**
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/nimbou-skills/skills ~/.agents/skills/nimbou-skills
   ```

   **Windows (PowerShell):**
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
   cmd /c mklink /J "$env:USERPROFILE\.agents\skills\nimbou-skills" "$env:USERPROFILE\.codex\nimbou-skills\skills"
   ```

3. **Restart Codex** (quit and relaunch the CLI) to discover the skills.

## Verify

```bash
ls -la ~/.agents/skills/nimbou-skills
```

You should see a symlink (or junction on Windows) pointing to your `~/.codex/nimbou-skills/skills` tree.

The linked skill tree exposes:
- backend-first core skills such as `nestjs-think`, `nestjs-plan`, and `executing-plans`
- NestJS-specific skills such as `nestjs-audit-http-tests`
- Nuxt-specific skills such as `nuxt-catalog`

## Updating

```bash
cd ~/.codex/nimbou-skills && git pull
```

The symlink exposes the latest cloned files immediately. If Codex does not pick up newly added skills, restart the CLI.

## Uninstalling

```bash
rm ~/.agents/skills/nimbou-skills
```

Optionally delete the clone: `rm -rf ~/.codex/nimbou-skills`.
