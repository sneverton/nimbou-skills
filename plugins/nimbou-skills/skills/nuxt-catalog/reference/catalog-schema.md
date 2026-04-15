# Catalog Schema

Each Vue SFC may include:

~~~vue
<catalog lang="json">
{
  "title": "Project Status Badge",
  "category": "display",
  "domain": "projects",
  "tags": ["project", "status", "badge"],
  "purpose": "Displays the lifecycle status of a project.",
  "useWhen": "Use in project lists, cards, and headers.",
  "avoidWhen": "Avoid for generic statuses; use StatusChip instead.",
  "status": "experimental",
  "replaces": "OldStatusBadge"
}
</catalog>
~~~

Required fields: `title`, `category`, `domain`, `tags`, `purpose`, `useWhen`, `avoidWhen`, `status`.

Optional fields: `replaces` (string or null, defaults to `null`).

Derived fields (computed by `nb-catalog generate`, not authored):
- `related` — grouped by folder/prefix convention
- `usedBy` — scanned from template references in components and pages

Allowed `status` values: `draft`, `experimental`, `stable`, `deprecated`.

Generated outputs:

- Rich catalog: `components.meta.json`
- Slim compatibility mirror: `.generated/component-catalog/components.meta.json`
