# Test Conventions

## Selector priority

1. getByRole()
2. label or accessible name
3. stable visible text
4. getByTestId()
5. justified fallback selectors

Never use internal Vuetify classes as the primary selector.
Never use `waitForTimeout()` as the primary synchronization strategy.

Use `data-testid` only when:
- the control has no reliable accessible contract
- the widget is complex enough that semantic selectors are unstable
- a stateful region needs a stable contract that the UI does not naturally expose

## Naming

Use kebab-case English identifiers:

- <module>-<section>-<element>-<action>

## Coverage

When applicable, cover:
- one critical happy path
- at least one meaningful non-happy-path state
- routes, filters, CRUD flows, or validation that matter to the bounded flow
- loading, empty, error, and destructive confirmation states when they are user-visible in that slice
