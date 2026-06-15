# Estándar de Ingeniería — [Empresa]

> Este archivo es el estándar **agnóstico de versión** de la empresa.
> Los repos de cliente lo importan y añaden encima su `🔒 VERSION LOCK`.
> Importa la matriz de versiones:
@docs/odoo-version-guardrails.md

## 0. Regla de oro (Odoo multi-versión)

- **NUNCA inventes APIs de Odoo "de memoria".** El modelo mezcla v14, v16 y v18 sin avisar.
- La **única fuente de verdad** es el código de la versión fijada en el repo (`vendor/odoo` o el MCP de docs declarado en el overlay del cliente). Si dudas de una firma, un tag de vista o un método del ORM, **léelo en el fuente de esa versión**, no lo recuerdes.
- Antes de escribir, consulta la sección "VERSION LOCK" del `CLAUDE.md` del repo. Si no existe, **detente y pregunta** qué versión de Odoo es.

## 1. Principios de diseño

- SOLID / DRY / KISS, no negociables.
- Diffs pequeños y revisables. Una tarea = un PR enfocado.
- Extiende, no reescribas: usa `_inherit` / `_inherits`. Nunca toques módulos del core.
- Toda decisión arquitectónica relevante va documentada en el PR.

## 2. Estructura de un módulo Odoo

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
- Sin secretos en código. Endpoints/keys en config, nunca hardcodeados.

## 4. Seguridad (default-deny)

- Cada modelo nuevo declara `ir.model.access.csv` y, si aplica, `record rules`.
- Permisos mínimos por grupo. Nada de `perm_unlink=1` salvo a managers.
- Validar input en controllers. `sudo()` solo justificado y comentado.

## 5. Git

- Ramas `feature/*` desde la rama del cliente (no desde `main` genérico).
- PR con: descripción, plan, versión Odoo afectada, checklist de tests.
- Squash merge. Borrar rama tras merge.

## 6. Cómo trabajar una tarea (flujo estándar)

1. **Explorar** — leer el módulo afectado + el fuente de la versión fijada. Sin código aún.
2. **Planificar** — usar *plan mode* para todo lo que toque modelos/campos/migraciones.
3.  Implementar — diff mínimo, respetando `_inherit` y la sintaxis de la versión.
4.  Verificar — correr el subagente `odoo-version-auditor` y los tests antes del PR.

## 7. Soporte (tickets sobre sistemas en vivo)

- Reproducir **antes** de tocar: test que falle o pasos de repro documentados.
- Confirmar la versión del cliente al inicio. Aplicar guardrails de esa versión.
- Si cambia el esquema → script de migración de datos en `migrations/`.

## 8. Enterprise Multi-Company/Website

- **`company_id` Obligatorio:** Todo modelo con datos específicos de compañía debe tener un campo `company_id`.
- **Definición del campo:** `company_id = fields.Many2one('res.company', string='Company', required=True, index=True, default=lambda self: self.env.company)`.
- **Consistencia Relacional:** Activar `_check_company_auto = True` en el modelo y `check_company=True` en campos relacionales (Many2one, Many2many) para evitar contaminación entre compañías.
- **Gestión de Contexto:** Usar `self.env.company` para la compañía activa y `self.env.companies` para las seleccionadas. Usar `with_company(company)` para cambios de contexto de forma segura.
- **Seguridad:** Validar siempre las `record rules` en entornos multi-compañía para asegurar el aislamiento de datos.

## 9. Herramientas y Plugins (Letzdoo Marketplace)

Este entorno integra plugins avanzados para Claude Code:
- **`odoo-development`**: Comandos como `/odoo-module`, `/odoo-review`, `/odoo-security`.
- **`odoo-query`**: Usa `/odoo-query` para consultas XML-RPC de solo lectura contra instancias en vivo.
- **`odoo-token-killer`**: Optimiza el uso de tokens resumiendo logs largos.

Los plugins se instalan automáticamente al inicializar un nuevo proyecto y ejecutar `claude`.
