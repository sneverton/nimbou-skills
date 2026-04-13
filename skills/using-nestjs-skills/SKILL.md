---
name: using-nestjs-skills
description: Use when starting any conversation in this repository to establish how the workflow skills should be discovered and applied
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute one narrow task, skip this skill.
</SUBAGENT-STOP>

# Using nestjs-skills

## Rule

If a workflow skill clearly applies, load it before acting.

Do not improvise around a matching workflow. The point of this repository is to keep execution disciplined.

## Priority

1. User request
2. `CLAUDE.md` or `AGENTS.md`
3. Loaded `nestjs-skills` workflow skills
4. Default harness behavior

## Supported Harnesses

### Claude Code

- Use the `Skill` tool to load skills.
- Do not open `SKILL.md` files directly once a skill should be invoked.

### Codex

- Skills are discovered natively from the installed directory.
- See `references/codex-tools.md` for tool mapping when a skill uses Claude-oriented tool names.

## Workflow Order

- New build/change request: start with `brainstorming`
- Approved design/spec: use `writing-plans`
- Ready implementation plan: use `subagent-driven-development` or `executing-plans`
- Bug or flaky behavior: use `systematic-debugging`
- Feature or fix implementation: use `test-driven-development`
- Before claiming completion: use `verification-before-completion`

## Red Flags

- "I can just inspect the repo first"
- "This is simple enough to skip the workflow"
- "I remember the skill well enough"
- "I only need one quick edit"

Those are usually attempts to bypass the process. Load the matching skill instead.
