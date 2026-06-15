# Guardrails de versión Odoo (v14 → v19)

Matriz de cambios que **más rompen** cuando el modelo mezcla versiones.
Cada overlay de cliente referencia solo la columna de SU versión.

> Última versión estable: **Odoo 19.0** (sept/oct 2025). Python 3.10+ (3.12 recomendado), PostgreSQL 13+.
> Verifica detalles en https://www.odoo.com/documentation/19.0/

## Vistas (XML)

| Tema | ≤ 16.0 | 17.0 | 18.0 / 19.0 |
|------|--------|------|-------------|
| Tag raíz de lista | `<tree>` | `<tree>` | **`<list>`** (tree deprecado) |
| `view_mode` en act_window | `tree,form` | `tree,form` | **`list,form`** |
| Visibilidad condicional | `attrs="{'invisible': [...]}"` | inline `invisible="..."` | inline `invisible="..."` (attrs **eliminado**) |
| `states="..."` en vistas | válido | eliminado | eliminado |

```xml
<!-- ❌ ≤16 -->
<field name="x" attrs="{'invisible': [('state','=','done')]}"/>
<!-- ✅ 17+ -->
<field name="x" invisible="state == 'done'"/>

<!-- ❌ ≤17 -->            <!-- ✅ 18/19 -->
<tree>...</tree>          <list>...</list>
```

## Python / ORM

| Tema | Antiguo | 17.0+ |
|------|---------|-------|
| Nombre visible | `name_get()` | **`_compute_display_name()`** |
| Comandos x2many | tuplas mágicas `(0,0,{...})`, `(6,0,[...])` | **`from odoo import Command`** → `Command.create({...})`, `Command.set([...])` |
| `states=` en campos `fields.*` | válido | **eliminado** (mover lógica a UI/compute) |

```python
# ❌ antiguo
'order_line': [(0, 0, {'product_id': p.id, 'product_uom_qty': 2})]
# ✅ 17+
from odoo import Command
'order_line': [Command.create({'product_id': p.id, 'product_uom_qty': 2})]
```

## Frontend (JS)

| Tema | v14 | v15-16 | 17.0+ |
|------|-----|--------|-------|
| Framework | widgets legacy + OWL parcial | OWL mayoritario | **OWL exclusivo** |
| SCSS | libsass | libsass | dart-sass |

## Herramienta de migración

Desde v18 existe `odoo-bin upgrade_code` para automatizar parte del salto (p.ej. `<tree>`→`<list>`):

```bash
./odoo-bin upgrade_code --addons-path=$ADDONS --from 17.0
```

> Revisa siempre el resultado a mano: el script puede colocar atributos fuera del tag.

## Enterprise & Multi-Company / Website

- **Multi-Website:** En modelos con soporte de sitio web, usar `website_id` para filtrado y `website_published` para visibilidad.
- **Record Rules (v17+):** El estándar para reglas multi-compañía ahora debe usar `company_ids` (plural) para soportar la selección múltiple de la UI.
- **Template de Regla:**

```xml
<record id="rule_id" model="ir.rule">
    <field name="name">Rule Name: multi-company</field>
    <field name="model_id" ref="model_name"/>
    <field name="domain_force">
        ['|', ('company_id', '=', False), ('company_id', 'in', company_ids)]
    </field>
</record>
```

## Regla operativa para Claude

1. Lee el `🔒 VERSION LOCK` del repo.
2. Aplica SOLO la columna de esa versión.
3. Si el ticket es de un cliente en v14 y otro en v19, **no reutilices recetas entre ramas**.
