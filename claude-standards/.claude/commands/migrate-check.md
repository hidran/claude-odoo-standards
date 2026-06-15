---
description: Audita el código del repo contra los guardrails de la versión fijada
---
Revisa el módulo `$1` (o todo el repo si no se indica) contra
`odoo-version-guardrails.md`, usando la columna de la versión del VERSION LOCK.

Reporta y propón fix para:
- `<tree>` que deba ser `<list>` (18/19)
- `attrs=`/`states=` que deban ser atributos inline (17+)
- `name_get()` que deba ser `_compute_display_name()` (17+)
- tuplas mágicas x2many que deban usar `from odoo import Command`
- `view_mode` con `tree` que deba ser `list` (18/19)
