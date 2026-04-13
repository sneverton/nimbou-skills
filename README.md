# nestjs-skills

`nestjs-skills` is a stripped-down fork that keeps a reusable engineering workflow while the skill library is being reshaped around `NestJS`, `Prisma`, `Clean Architecture`, and `SOLID` principles.

This repository is no longer trying to be a general-purpose upstream mirror. The current goal is to preserve only the workflow core and the minimum bootstrap needed for `Claude Code` and `Codex`.

## Current Status

- Supported harnesses: `Claude Code` and `Codex`
- Current focus: planning, execution, debugging, review, and skill-authoring workflows
- Next phase: replace generic upstream-oriented guidance with stack-specific NestJS guidance

## Included Skills

- `using-nestjs-skills`
- `brainstorming`
- `writing-plans`
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

## Repository Layout

- `skills/` contains the reusable skill library
- `agents/` contains auxiliary agent prompts
- `.claude-plugin/` and `hooks/` contain the Claude bootstrap
- `.codex/INSTALL.md` documents the Codex setup path
- `docs/plans/` is the default location for generated plans and design artifacts

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
- `hooks/hooks.json`
- `hooks/session-start`

Point your Claude local plugin setup at this repository and make sure the hook is enabled so `using-nestjs-skills` is injected at session start.

## Notes

- This fork intentionally removed marketplace, OpenCode, Cursor, Gemini, Copilot, and upstream contribution scaffolding.
- The repository is expected to keep changing while the NestJS-specific skill set is introduced.

## License

MIT License. See `LICENSE`.
