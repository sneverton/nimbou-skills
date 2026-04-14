---
name: nuxt-debug
description: Use for Nuxt/Vuetify browser bugs, hydration issues, or flaky frontend behavior before proposing fixes. Prefer DevTools MCP and/or Playwright evidence first.
---

# Nuxt Systematic Debugging

Use this skill when the bug is clearly frontend-first: route rendering, hydration, browser state, network sequencing, Vuetify interaction, or Playwright failures around a Nuxt app.

If the failure is primarily in NestJS, Prisma, or backend contracts, use `nestjs-debug` instead.

## Core Rule

```text
NO FRONTEND FIXES BEFORE LIVE BROWSER EVIDENCE
```

A guessed selector change, watcher tweak, or SSR guard is still guessing if you have not observed the runtime state.

## Primary Tools

Prefer live evidence from the browser before editing code.

In Codex:
- use `mcp__chrome_devtools__take_snapshot` to inspect the rendered accessibility tree
- use `mcp__chrome_devtools__list_console_messages` for hydration, runtime, and Vue warnings
- use `mcp__chrome_devtools__list_network_requests` and `get_network_request` for failed API or asset calls
- use `mcp__chrome_devtools__evaluate_script` to inspect `window`, DOM state, route params, and client-side data

Use Playwright when:
- the bug needs scripted reproduction
- the same interaction must be repeated
- timing or state transitions need assertions
- the failure already exists in E2E coverage

If DevTools MCP is unavailable in the current harness, fall back to Playwright plus application logs.

## When To Use

Use for:
- SSR or hydration mismatch
- page renders wrong state after navigation
- stale filters, pagination, or query-param sync
- component interaction bugs in Vuetify dialogs, forms, tables, or drawers
- frontend-only auth or route-guard issues
- flaky Playwright failures caused by selectors, timing, or network sequencing

## Mandatory Flow

### Phase 1: Reproduce in the Browser

1. Reproduce with exact route, viewport, auth state, and seed data.
2. Capture what the user actually sees:
   - rendered text and controls
   - console output
   - network requests
   - route and query params
   - DOM state before and after the interaction
3. Separate first-load, client navigation, and refresh behavior.
   - SSR-only failures and client-only failures usually have different causes.

### Phase 2: Locate the Owning Boundary

Trace the failure through the frontend path:

```text
Route -> page/layout -> composable/store -> component -> network call -> rendered state
```

Determine where the contract first breaks:
- wrong route params or query parsing
- missing fetch trigger or stale watch dependency
- store mutation not reflected in UI
- Vuetify component not receiving expected props
- backend response is correct, but frontend mapping is wrong
- browser request is wrong before it ever reaches the backend

Do not treat a browser symptom as proof that the backend is wrong.

### Phase 3: Compare With a Working Path

Find the nearest working example in the same Nuxt codebase:
- same page pattern
- same composable or store pattern
- same form submission flow
- same table/filter/pagination behavior
- same Playwright selector style

Compare:
- `useAsyncData` or fetch lifecycle
- watchers and computed dependencies
- route sync and navigation timing
- prop flow into Vuetify components
- loading, empty, and error states
- selector stability and waiting strategy in tests

### Phase 4: Form One Hypothesis

State it explicitly:

```text
I think X is the root cause because Y.
```

Then test only that hypothesis.

Examples:
- "Hydration mismatch starts because the page reads `window` during SSR."
- "The table never refreshes because the watch source omits `page`."
- "The Playwright failure is test-side because the selector depends on transient Vuetify markup."

### Phase 5: Fix and Verify

1. Add or update the narrowest failing check first.
   - Playwright for user-visible regressions
   - component or composable tests when the failure is local and already supported

   Use `nestjs-skills:nuxt-test` when you need to expand or stabilize Playwright coverage.

2. Apply one fix at the owning layer.
   - route/composable for state-sync bugs
   - page/component for rendering bugs
   - test selectors/waits for test-only failures

3. Verify with the same live evidence used during investigation.
   - rerun the browser path
   - recheck console and network
   - rerun the relevant Playwright coverage

4. If the fix fails, stop and reopen the investigation.
   - After 2 failed fixes, your ownership assumption is probably wrong.
   - After 3 failed fixes, question the frontend boundary or data-flow design.

## Nuxt-Specific Smells

Stop and investigate when you see:
- `window`, `document`, or storage access during SSR without a guard
- duplicate fetches from overlapping lifecycle hooks and watchers
- route query state drifting from local component state
- UI fixes that hide a stale store or composable bug
- waits based on `timeout` instead of observable conditions
- Playwright selectors tied to generated Vuetify structure instead of semantics

## Red Flags

If you catch yourself thinking:
- "Let's add `nextTick` and see"
- "Maybe `await page.waitForTimeout(1000)` fixes it"
- "This is probably hydration weirdness"
- "I'll just force `client-only`"
- "The selector worked locally once"

Stop. Gather more browser evidence.

## Quick Reference

| Phase | Frontend focus | Exit criteria |
|-------|----------------|---------------|
| 1. Reproduce | Exact browser state, console, network, route | Failure observed with evidence |
| 2. Boundary | Route, composable, component, request, render ownership | First broken contract identified |
| 3. Compare | Working Nuxt/Vuetify path | Concrete differences listed |
| 4. Hypothesis | One explanation only | Confirmed or rejected with evidence |
| 5. Fix | Smallest test, one fix, browser recheck | Bug resolved and tests stable |

## Related Skills

- `nestjs-skills:nuxt-test`
- `nestjs-skills:nuxt-audit`
- `nestjs-skills:verification-before-completion`
