# acme-erp-odoo19 (repo de cliente — EJEMPLO)

Repo de cliente de ejemplo que **consume el estándar de empresa** (`../claude-standards`)
y fija Odoo **19.0**. Demuestra el patrón "estándar + VERSION LOCK".

- `CLAUDE.md` → importa el estándar y añade el candado de versión 19.0.
- `addons/acme_sales/` → módulo de ejemplo, **sintaxis correcta de Odoo 19**:
  - `<list>` como tag raíz (no `<tree>`)
  - atributos inline `invisible=` / `readonly=` (no `attrs`)
  - `_compute_display_name()` (no `name_get()`)
  - `from odoo import Command` (no tuplas mágicas)
  - `view_mode="list,form"`

## Estructura
```
acme-erp-odoo19/
├── CLAUDE.md                 # overlay con 🔒 VERSION LOCK 19.0
├── .claude/settings.json
├── .gitmodules               # vendor/odoo @ 19.0 (fuente de verdad)
└── addons/acme_sales/
    ├── __manifest__.py        # version 19.0.1.0.0
    ├── models/sale_order.py   # _inherit sale.order + modelo acme.sample
    ├── views/*.xml            # <list>, inline attrs
    ├── security/ir.model.access.csv
    ├── i18n/es.po
    └── tests/test_acme_sample.py
```

## Cómo se generó (desde claude-standards)
```bash
cd claude-standards
./scripts/init-odoo-project.sh --client=ACME --odoo=19.0 --python=3.12 --deploy="odoo.sh (production)"
```
