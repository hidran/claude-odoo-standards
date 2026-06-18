---
description: Genera un modelo Odoo nuevo (clase, accesos, vista y test) respetando el VERSION LOCK
---
Crea el modelo `$1` (nombre tecnico, p.ej. `acme.sample`) en el modulo indicado por `$2`
(o el modulo activo del repo).

Aplica la skill `odoo-engineering-standard` y `odoo-version-guardrails` (columna del
VERSION LOCK). Genera:
1. `models/<archivo>.py` con `class` heredando `models.Model`, `_name`, `_description`,
   `_order`, y un `_compute_display_name()` si aplica (NO `name_get` en 17+).
2. Si maneja datos de compania, anade `company_id` segun la skill `verify-multi-company`.
3. `security/ir.model.access.csv` con permisos MINIMOS por grupo (default-deny).
4. Una vista basica (`<list>`/`<tree>` segun version) + accion + menu.
5. Un test `TransactionCase` minimo (skill `odoo-testing`).
6. Registra imports en `models/__init__.py` y datos en `__manifest__.py`.

No inventes firmas: verifica en `vendor/odoo`. Diff minimo, una responsabilidad.
