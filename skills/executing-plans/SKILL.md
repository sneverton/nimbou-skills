---
name: executing-plans
description: Use when you have an approved implementation plan and need to execute it with review checkpoints, including dependency-aware parallel groups when the plan defines them.
---

# Executing Plans

## Overview

Load the plan, review it critically, detect whether it is task-driven or group-driven, then execute it without guessing.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

If subagents are available, `nestjs-skills:subagent-driven-development` is still the better default. Use this skill when execution should stay inline in the current session.

## Step 1: Load and Review

1. Read the plan file
2. Review it critically
3. Raise any blockers or missing assumptions before starting
4. Detect execution shape:
   - **Task mode:** traditional ordered tasks with checklists
   - **Group mode:** explicit execution groups with dependency order and parallelizable items
5. Create TodoWrite and proceed only when the plan is executable

## Step 2: Execute

### Task mode

For each task:

1. Mark it as in progress
2. Follow each step exactly
3. Run the specified verifications
4. Mark it complete

### Group mode

For each execution group:

1. Confirm which files or tasks are independent inside the group
2. Dispatch independent items in parallel when the tool/runtime supports it
3. Wait for the whole group to finish before starting dependent groups
4. If one item in the group fails, stop all downstream dependent groups
5. Report the exact file, task, or group that blocked the flow

Use group mode when the plan explicitly models dependency order for multi-slice or frontend-heavy work. Do not flatten the topology unless the user approves it.

## Step 3: Complete Development

After all tasks complete and verifications pass:

- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- Use `nestjs-skills:finishing-a-development-branch`

## When to Stop

Stop immediately when:

- you hit a blocker
- the plan has critical gaps
- an instruction is unclear
- verification fails repeatedly
- a grouped plan encounters a failure that invalidates downstream groups

Ask for clarification instead of guessing.

## When to Revisit Review

Return to Step 1 when:

- the user updates the plan
- the approach needs rethinking
- a blocker shows the plan is incomplete or inconsistent

## Remember

- review the plan critically first
- follow plan steps exactly
- do not skip verifications
- respect dependency order and parallel groups when they exist
- stop when blocked
- do not start implementation on `main` or `master` without explicit user consent

## Integration

Required workflow skills:

- `nestjs-skills:using-git-worktrees` - set up an isolated workspace before starting
- `nestjs-skills:nestjs-plan` - creates task-driven backend plans for this skill to execute
- `nestjs-skills:nuxt-plan` - creates group-driven frontend plans for this skill to execute
- `nestjs-skills:finishing-a-development-branch` - completes the branch after execution

## Output Discipline

When execution completes or stops, report:

- what was executed
- what was verified
- what failed or remains blocked
- whether the failure belongs to one task, one file, or one execution group
