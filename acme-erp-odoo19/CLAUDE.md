# Cliente: ACME — Overlay

@import ../claude-standards/CLAUDE.md

## 🔒 VERSION LOCK (no negociable)
- Odoo **19.0** Community. Python 3.12.
- Fuente de verdad: `./vendor/odoo` (submódulo, solo lectura, rama `19.0`).
  Si dudas de una API, un tag de vista o un método del ORM, **LÉELO AHÍ**. No lo recuerdes.
- Deploy: odoo.sh (rama `production`) + infraestructura propia en la nube (staging).

## Guardrails activos para 19.0
Referencia completa: `../claude-standards/docs/odoo-version-guardrails.md` (columna 18/19).

Recordatorio de lo que MÁS rompe en este repo:
- Vistas de lista: tag raíz **`<list>`** (NO `<tree>`).
- `view_mode` de las acciones: **`list,form`** (NO `tree,form`).
- Visibilidad/lectura condicional: atributos **inline** `invisible="..."`, `readonly="..."` (NO `attrs="{...}"`).
- Nombre visible: **`_compute_display_name()`** (NO `name_get()`).
- Comandos x2many: **`from odoo import Command`** → `Command.create(...)`, `Command.set(...)` (NO tuplas `(0,0,{})`).

## Quirks del cliente
- Localización: `l10n_ec` (Ecuador), facturación electrónica SRI.
- Módulos custom: `acme_sales`.
- Mercado: español LatAm. Traducciones en `i18n/` con variantes regionales si se piden.
