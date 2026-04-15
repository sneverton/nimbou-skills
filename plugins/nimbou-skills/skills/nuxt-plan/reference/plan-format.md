# Plan Format

The plan should read like an execution brief, not a loose idea list.
Return it directly in the chat by default. Only turn it into a saved Markdown document if the user explicitly asks for a file.

## Required sections

- `## Contexto` for the concrete frontend slice being implemented
- `## Decisoes Fechadas` for resolved reuse, ownership, and state decisions
- `## Arquivos` with exact paths and dependency grouping
- `## Grupos de Execucao` for parallel versus serial work
- `## Riscos e Validacoes` for responsive, data, or interaction risks
- `## Pos-execucao` for catalog verification and testing follow-up

## Naming

- Components: `PascalCase.vue`
- Composables: `useEntityAction.ts`
- Configs: `kebab-case.ts`

## Nuxt structure

- Use file-based routing under `pages/`.
- Rely on Nuxt auto-imports for `components/` and `composables/`.
- Prefer `<script setup lang="ts">` and `<style scoped lang="scss">`.

## Layout strategy

- CSS Grid for 2D page sections.
- Flexbox for 1D alignment.
- Container queries when local responsiveness matters.

## Grouping rules

- Parallel for independent components and isolated configs.
- Serial for shared contracts, shared composables, and final page integration.
- Always leave page integration, catalog verification, and `/test` suggestions for the end.

## Questions to close before planning

- Which exact route or page file owns the work?
- Which exact component and composable file names are being created or modified?
- Which files can run in parallel versus serial based on dependencies?
- Which test scope matters most after implementation?
