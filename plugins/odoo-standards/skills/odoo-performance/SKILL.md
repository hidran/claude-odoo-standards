---
name: odoo-performance
description: Optimizar rendimiento en Odoo — evitar N+1, usar read_group/search_read, prefetch de recordsets, indices, computes store vs no-store, y vistas SQL (_auto=False). Usalo cuando una accion sea lenta, proceses muchos registros, o hagas reporting/agregaciones.
---

# Rendimiento en Odoo

> Mide antes de optimizar. La mayoria de cuellos son N+1 (consultas dentro de bucles) o
> computes mal definidos.

## Evitar N+1

- No hagas `search`/`browse` dentro de un bucle. Carga una vez y opera sobre el recordset.
- Odoo hace **prefetch** automatico al acceder a un campo de un recordset: itera el
  recordset entero, no registros sueltos, para que el prefetch agrupe las lecturas.
- `mapped("a.b.c")`, `filtered`, `filtered_domain` operan sin disparar consultas por
  registro.

## Agregaciones: read_group

Para totales/conteos por grupo NO itves registros: usa `read_group` (o `_read_group`):

```python
data = self.env["sale.order"].read_group(
    domain=[("state", "=", "sale")],
    fields=["amount_total:sum"],
    groupby=["partner_id"],
)
```

Confirma la firma exacta y el nombre (`read_group` vs `_read_group`) en `vendor/odoo` de
tu version — cambio entre releases.

## search_read

Cuando solo necesitas datos (no recordset con logica), `search_read` evita instanciar y
re-leer:

```python
rows = self.env["product.product"].search_read([("sale_ok", "=", True)], ["name", "lst_price"])
```

## Campos computed

- `store=True` materializa el valor (rapido para buscar/agrupar/ordenar) a costa de
  recomputo en cada cambio de dependencia. Usalo cuando el campo se filtra o agrupa.
- Sin `store`, no se puede buscar por el campo y se recalcula al leer.
- `@api.depends` preciso evita recomputos innecesarios.

## Indices

- `index=True` en campos por los que filtras/ordenas con frecuencia (FKs, codigos,
  estados).
- `_sql_constraints` con UNIQUE crea indice util ademas de integridad.

## Reporting pesado: vista SQL

Para dashboards/agregados de solo lectura sobre muchas filas, un modelo con
`_auto = False` respaldado por una vista SQL suele superar a calcular en Python:

```python
class SaleReport(models.Model):
    _name = "acme.sale.report"
    _auto = False
    # init() con CREATE OR REPLACE VIEW ... — revisa un ejemplo del core en vendor/odoo
```

## Checklist

- Bucle con `search`/`browse` dentro -> reescribir.
- Compute no-store usado en `search`/`order` -> ponerlo `store=True` o repensar.
- Listas/reportes grandes -> `read_group`/`search_read`/vista SQL.
- Campo filtrado sin indice -> `index=True`.
