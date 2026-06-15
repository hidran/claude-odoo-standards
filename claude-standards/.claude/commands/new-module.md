---
description: Andamia un módulo Odoo nuevo respetando el VERSION LOCK del repo
---
Crea un módulo Odoo llamado `$1` para ESTE repo.

Pasos:
1. Lee el `🔒 VERSION LOCK` del CLAUDE.md y la columna correspondiente de
   `odoo-version-guardrails.md`. Usa SOLO la sintaxis de esa versión.
2. Genera la estructura: `__manifest__.py` (con `version` = `<MAJOR>.0.1.0.0`),
   `models/`, `views/`, `security/ir.model.access.csv`, `tests/`.
3. Vistas: usa el tag raíz correcto (`<list>` en 18/19, `<tree>` en ≤17) y
   atributos inline (`invisible=`) — nunca `attrs`.
4. Añade un test `TransactionCase` mínimo.
5. NO inventes APIs: verifica firmas en el fuente de la versión fijada.
