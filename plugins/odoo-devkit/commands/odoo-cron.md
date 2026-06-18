---
description: Genera una tarea programada (ir.cron) con su metodo de modelo idempotente
---
Crea un cron `$1` que ejecute logica periodica sobre el modelo `$2`.

1. Metodo en el modelo (p.ej. `_cron_acme_sync`) **idempotente** y por lotes: procesa en
   bloques, registra con `logging.getLogger(__name__)` (NO `print`), y maneja errores sin
   dejar la BD inconsistente.
2. `data/<archivo>_cron.xml`: registro `ir.cron` con `model_id`, `state="code"`,
   `code="model._cron_acme_sync()"`, `interval_number`/`interval_type`, `active`.
   Considera `noupdate="1"` para no pisar la config del cliente al actualizar.
3. Carga el XML en `data` del `__manifest__.py`.
4. Test que invoque el metodo del cron directamente y verifique el efecto.

Aplica patrones de `odoo-orm-patterns` y `odoo-performance` (evita N+1 en el barrido).
Verifica los campos de `ir.cron` en `vendor/odoo` de tu version.
