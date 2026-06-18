# Cliente: ACME

El estándar de empresa llega vía el **plugin `odoo-standards`** del marketplace privado
(ver `.claude/settings.json`). Las reglas, skills, commands, agents y hooks se cargan
desde el plugin; este archivo solo fija lo específico de ACME.

## 🔒 VERSION LOCK (no negociable)
- Odoo **19.0** Community. Python 3.12.
- Fuente de verdad: `./vendor/odoo` (submódulo, solo lectura, rama `19.0`).
  Si dudas de una API, un tag de vista o un método del ORM, **LÉELO AHÍ**. No lo recuerdes.
- Deploy: odoo.sh (rama `production`) + infraestructura propia en la nube (staging).

## Guardrails activos para 19.0
La skill `odoo-version-guardrails` aplica la columna 18/19. Recordatorio de lo que MÁS
rompe en este repo:
- Vistas de lista: tag raíz **`<list>`** (NO `<tree>`).
- `view_mode` de las acciones: **`list,form`** (NO `tree,form`).
- Visibilidad/lectura condicional: atributos **inline** `invisible="..."`, `readonly="..."` (NO `attrs="{...}"`).
- Nombre visible: **`_compute_display_name()`** (NO `name_get()`).
- Comandos x2many: **`from odoo import Command`** → `Command.create(...)`, `Command.set(...)` (NO tuplas `(0,0,{})`).

## Quirks del cliente
- Localización: `l10n_ec` (Ecuador), facturación electrónica SRI.
- Módulos custom: `acme_sales`.
- Mercado: español LatAm. Traducciones en `i18n/` con variantes regionales si se piden.
