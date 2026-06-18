---
name: odoo-orm-patterns
description: Patrones correctos del ORM de Odoo al escribir modelos Python — recordsets, environment, campos computed/related, @api.depends/onchange/constrains, create/write en lote, search vs browse, y comandos x2many. Usalo al crear o editar models/*.py. Verifica firmas exactas en vendor/odoo de la version fijada.
---

# Patrones del ORM de Odoo

> Regla de oro: no inventes firmas. Si dudas de un metodo (`search_read`, `read_group`,
> `_read_group`, `flush`), LEELO en `vendor/odoo` de la version del repo. Esta skill da
> patrones; la version manda en los detalles.

## Recordsets y environment

- Un recordset es una coleccion; itera con `for rec in self:` y nunca asumas `len==1`
  salvo que uses `self.ensure_one()`.
- `self.env['model']` para acceder a otro modelo; `self.env.user`, `self.env.company`,
  `self.env.ref('module.xmlid')` para datos de contexto.
- Prefiere operaciones vectorizadas sobre recordsets a bucles registro-a-registro.

## Campos computed / related

```python
total = fields.Monetary(compute="_compute_total", store=True)

@api.depends("line_ids.subtotal")          # dependencias COMPLETAS y precisas
def _compute_total(self):
    for rec in self:                        # SIEMPRE itera self
        rec.total = sum(rec.line_ids.mapped("subtotal"))
```

- `store=True` solo si necesitas buscar/agrupar por el campo o por rendimiento; conlleva
  recomputo. Sin `store`, se calcula al vuelo.
- `related="partner_id.country_id"` para atajos; evita computes triviales.
- Computes que dependen de la compania: `@api.depends_context('company')`.

## onchange vs constrains

- `@api.onchange('field')`: solo UX en el formulario (rellenar/avisar). NO garantiza
  integridad — puede saltarse por import/API.
- `@api.constrains('field')`: validacion real de integridad; lanza `ValidationError`.
- Validacion a nivel BD: `_sql_constraints`.

## create / write en lote

- `@api.model_create_multi` + firma `def create(self, vals_list):` para creacion masiva.
- Pasa listas de vals; evita crear dentro de bucles.
- x2many: usa `from odoo import Command` (ver skill `odoo-version-guardrails` para la
  sintaxis por version).

## search / browse / lectura

- `search([...])` devuelve recordset; `search_read` y `read_group` evitan N+1 cuando solo
  necesitas datos agregados (ver skill `odoo-performance`).
- No hagas `search` dentro de un bucle: construye el dominio una vez.
- `mapped`, `filtered`, `sorted` para transformar recordsets sin SQL extra.

## Errores comunes

- Iterar `self` y escribir asumiendo un solo registro sin `ensure_one()`.
- `@api.depends` incompleto -> valores obsoletos.
- `sudo()` para "arreglar" permisos en vez de declarar accesos/reglas (ver
  `odoo-security-reviewer`).
