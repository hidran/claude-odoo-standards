# claude-odoo-standards — marketplace de la empresa

Este repo es el **marketplace privado** de Claude Code de la empresa. Aloja el plugin
`odoo-standards`, que distribuye el estándar de ingeniería Odoo (skills, commands,
agents, hooks) a todos los repos de cliente.

> Estás trabajando en la **fuente** del estándar, no en un repo de cliente.
> La fuente canónica del estándar es `plugins/odoo-standards/`, NO este archivo.

## Estructura

- `.claude-plugin/marketplace.json` — manifiesto del marketplace (nuestro plugin + plugins Letzdoo).
- `plugins/odoo-standards/` — el plugin:
  - `skills/odoo-engineering-standard/` — estándar agnóstico (reglas de oro, calidad, seguridad).
  - `skills/odoo-version-guardrails/` — matriz v14→v19 (fuente única; el VERSION LOCK del cliente selecciona la columna).
  - `skills/verify-multi-company/` — validación de aislamiento multi-compañía.
  - `commands/`, `agents/`, `hooks/`.
- `scaffold/` + `scripts/init-odoo-project.sh` — generador de repos de cliente thin auto-enrolados.
- `managed/` — docs de la vía de enforcement opcional (managed-settings vía MDM).
- `docs/` — diseño, rollout y referencia humana.

## Cómo mantenerlo

- **Edita el estándar en `plugins/odoo-standards/skills/…`.** No dupliques contenido en
  `docs/` ni en este `CLAUDE.md`: la skill es la única fuente.
- Sube `version` en `plugins/odoo-standards/.claude-plugin/plugin.json` en cada cambio
  con impacto; los repos de cliente reciben la actualización al refrescar el plugin.
- Este repo se prueba a sí mismo: `.claude/settings.json` enrola el plugin vía
  marketplace `directory` (`path: "."`), así los cambios se ven en vivo aquí.

## Cómo lo consume un repo de cliente

1. `init-odoo-project.sh` genera un `CLAUDE.md` thin (solo `🔒 VERSION LOCK`) y un
   `.claude/settings.json` con `extraKnownMarketplaces` + `enabledPlugins`.
2. Al abrir `claude` en ese repo, el plugin aporta el estándar completo.
3. Ejemplo funcionando: `acme-erp-odoo19/` (Odoo 19, módulo `acme_sales`).
