---
name: odoo-engineering-standard
description: Estandar de ingenieria de la empresa para CUALQUIER trabajo en modulos Odoo (crear/editar modelos, vistas, seguridad, controllers, tests, PRs, tickets de soporte). Define las reglas de oro multi-version, principios de diseno, compuertas de calidad, seguridad default-deny y estandares enterprise/multi-compania. Usalo al empezar cualquier tarea Odoo.
---

# Estandar de Ingenieria Odoo — [Empresa]

Estandar **agnostico de version**. La version concreta la fija el `🔒 VERSION LOCK`
del `CLAUDE.md` del repo; para las diferencias de sintaxis entre versiones usa la skill
`odoo-version-guardrails`.

## 0. Regla de oro (Odoo multi-version)

- **NUNCA inventes APIs de Odoo "de memoria".** El modelo mezcla v14, v16 y v18 sin avisar.
- La **unica fuente de verdad** es el codigo de la version fijada en el repo
  (`vendor/odoo` o el MCP de docs declarado en el overlay del cliente). Si dudas de una
  firma, un tag de vista o un metodo del ORM, **leelo en el fuente de esa version**, no lo recuerdes.
- Antes de escribir, consulta la seccion `🔒 VERSION LOCK` del `CLAUDE.md` del repo.
  Si no existe, **detente y pregunta** que version de Odoo es.

## 1. Principios de diseno

- SOLID / DRY / KISS, no negociables.
- Diffs pequenos y revisables. Una tarea = un PR enfocado.
- Extiende, no reescribas: usa `_inherit` / `_inherits`. Nunca toques modulos del core.
- Toda decision arquitectonica relevante va documentada en el PR.

## 2. Estructura de un modulo Odoo

```
mi_modulo/
├── __init__.py
├── __manifest__.py
├── models/
├── views/
├── security/
│   └── ir.model.access.csv
├── data/
├── wizards/
├── report/
├── controllers/
├── static/
├── i18n/
└── tests/
```

## 3. Calidad (compuertas)

- `pre-commit` obligatorio: `black`, `isort`, `flake8`, `pylint-odoo`.
- Toda funcionalidad lleva tests: `odoo.tests.common.TransactionCase`, decorados con `@tagged`.
- Sin `print()`. Logging con `logging.getLogger(__name__)`.
- Sin secretos en codigo. Endpoints/keys en config, nunca hardcodeados.

## 4. Seguridad (default-deny)

- Cada modelo nuevo declara `ir.model.access.csv` y, si aplica, `record rules`.
- Permisos minimos por grupo. Nada de `perm_unlink=1` salvo a managers.
- Validar input en controllers. `sudo()` solo justificado y comentado.
- Para una revision dedicada, lanza el subagente `odoo-security-reviewer`.

## 5. Git

- Ramas `feature/*` desde la rama del cliente (no desde `main` generico).
- PR con: descripcion, plan, version Odoo afectada, checklist de tests.
- Squash merge. Borrar rama tras merge.

## 6. Como trabajar una tarea (flujo estandar)

1. **Explorar** — leer el modulo afectado + el fuente de la version fijada. Sin codigo aun.
2. **Planificar** — usar *plan mode* para todo lo que toque modelos/campos/migraciones.
3. **Implementar** — diff minimo, respetando `_inherit` y la sintaxis de la version.
4. **Verificar** — correr el subagente `odoo-version-auditor` y los tests antes del PR.

## 7. Soporte (tickets sobre sistemas en vivo)

- Reproducir **antes** de tocar: test que falle o pasos de repro documentados.
- Confirmar la version del cliente al inicio. Aplicar guardrails de esa version.
- Si cambia el esquema → script de migracion de datos en `migrations/`.
- El comando `/fix-ticket` encapsula este flujo.

## 8. Enterprise Multi-Company / Website

- **`company_id` obligatorio:** todo modelo con datos especificos de compania debe tener `company_id`.
- **Definicion del campo:** `company_id = fields.Many2one('res.company', string='Company', required=True, index=True, default=lambda self: self.env.company)`.
- **Consistencia relacional:** activar `_check_company_auto = True` y `check_company=True`
  en campos relacionales (Many2one, Many2many) para evitar contaminacion entre companias.
- **Gestion de contexto:** `self.env.company` para la compania activa, `self.env.companies`
  para las seleccionadas; `with_company(company)` para cambios de contexto seguros.
- **Seguridad:** validar siempre las `record rules` para asegurar el aislamiento de datos.
- Para validar cumplimiento usa la skill `verify-multi-company` y el subagente `odoo-enterprise-auditor`.

## 9. Herramientas y plugins disponibles

El plugin `odoo-standards` aporta:
- **Commands:** `/new-module`, `/migrate-check`, `/fix-ticket`, `/gen-i18n`.
- **Agents:** `odoo-version-auditor`, `odoo-security-reviewer`, `odoo-enterprise-auditor`.
- **Skills de conocimiento:** `odoo-version-guardrails`, `odoo-orm-patterns`,
  `odoo-testing`, `odoo-performance`, `odoo-views-qweb`, `odoo-migrations`,
  `verify-multi-company`.

El plugin hermano `odoo-devkit` aporta andamiaje: `/odoo-model`, `/odoo-field`,
`/odoo-wizard`, `/odoo-report`, `/odoo-controller`, `/odoo-cron` y el agente
`odoo-perf-auditor`.

El marketplace de la empresa tambien referencia plugins curados de Letzdoo
(`odoo-development`, `odoo-query`, `odoo-token-killer`); instalalos desde el mismo
marketplace si tu tarea los necesita.
