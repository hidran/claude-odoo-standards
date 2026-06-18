---
description: Anade un campo a un modelo (incl. computed/related/Monetary) con sus dependencias y vista
---
Anade el campo `$1` al modelo `$2`.

Pregunta o infiere el tipo (Char, Many2one, Monetary, Selection, computed, related...) y
aplica los patrones de la skill `odoo-orm-patterns`:
1. Define el campo en `models/*.py`. Para computed: metodo `_compute_*` que itera `self`
   y `@api.depends(...)` COMPLETO; decide `store=True` solo si se busca/agrupa/ordena por
   el campo (skill `odoo-performance`).
2. Si es relacional en entorno multi-compania, anade `check_company=True`.
3. Anade el campo a la(s) vista(s) relevante(s) por HERENCIA (xpath/position), con la
   sintaxis de version correcta (skill `odoo-views-qweb` + `odoo-version-guardrails`).
4. Si afecta esquema sobre datos existentes, valora un script en `migrations/` (skill
   `odoo-migrations`).
5. Anade/actualiza un test que cubra el campo.
