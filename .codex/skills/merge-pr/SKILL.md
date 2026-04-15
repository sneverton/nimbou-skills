---
name: merge-pr
description: Merge one PR or multiple ready PRs after validating status, showing the effective state, and getting explicit confirmation.
---

# Merge Pull Request

Use this skill when the user wants to merge one PR or several ready PRs.

This skill is merge-focused. It does not perform code review. If the user wants review first, that is a separate workflow.

## Modes

Choose the mode from the user's request and any PR identifiers already present in context:

- **Single mode**: a PR number or one clearly identified PR is provided
- **Batch mode**: the user asks to merge ready PRs, merge multiple PRs, or merge all eligible PRs

## Core Rules

- Never merge without showing the effective PR state first
- Never batch-merge without explicit confirmation
- Never merge a draft PR
- If immediate merge is blocked but the PR is otherwise eligible, offer auto-merge
- Prefer remote PR state over local branch assumptions

## Phase 1: Resolve Target

### Single mode

1. Resolve the target PR number
2. Fetch PR metadata
3. Confirm the repo, base branch, head branch, title, and current state

### Batch mode

1. List candidate PRs
2. Filter to ready or mergeable PRs
3. Build a concise summary table before acting

## Phase 2: Validate Eligibility

For each PR, verify:

- PR is open
- PR is not draft
- merge conflicts are not reported
- required checks are complete or passing
- required approvals or review gates are satisfied when that status is available

If any PR is not eligible, classify it as:

- `blocked`
- `auto-merge candidate`
- `ready now`

## Phase 3: Show Effective State

Before any merge action, show:

- PR number and title
- base and head branches
- checks summary
- review or approval summary
- mergeability status
- changed files summary

For batch mode, show one line per PR with the intended action.

## Phase 4: Confirm Action

### Single mode

Ask:

```text
PR #<number> is <ready now | auto-merge candidate | blocked>.
Action:
1. Merge now
2. Enable auto-merge
3. Cancel
```

### Batch mode

Ask for explicit confirmation after showing the table:

```text
<N> PRs are eligible for merge or auto-merge.
Type `merge` to continue, or `cancel` to stop.
```

## Phase 5: Execute

### Immediate merge

Use the GitHub CLI when immediate merge is available:

```bash
gh pr merge <number> --merge --delete-branch=false
```

Use `--squash` or `--rebase` only if the user explicitly requests a different strategy.

### Auto-merge

If immediate merge is blocked but the PR is otherwise eligible, enable auto-merge through the GitHub integration when supported.

### Batch execution

Process PRs one by one:

1. Merge immediately if ready now
2. Enable auto-merge if not ready now but eligible for it
3. Skip blocked PRs
4. Keep going after per-PR failures and report them clearly

## Phase 6: Report Result

For each PR, report one of:

- `merged`
- `auto-merge enabled`
- `skipped`
- `failed`

Always include:

- PR number
- final action
- short reason when not merged immediately

## Safety Rules

- Do not guess mergeability from local git state alone
- Do not silently downgrade from merge to auto-merge
- Do not merge multiple PRs just because they share a branch target
- Do not delete branches unless the user explicitly asks for it
