---
name: odoo-testing
description: Como escribir y ejecutar tests de Odoo — TransactionCase, @tagged, Form() para emular la UI, aislamiento de datos, y tags post_install/at_install. Usalo al anadir tests en tests/ o al reproducir un bug antes de arreglarlo. Verifica helpers exactos en vendor/odoo.
---

# Testing en Odoo

> Toda funcionalidad lleva test. Para un bug, primero un test que FALLE (reproduce),
> luego el fix.

## Estructura minima

```python
from odoo.tests.common import TransactionCase
from odoo.tests import tagged

@tagged("post_install", "-at_install")
class TestAcmeSale(TransactionCase):

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.partner = cls.env["res.partner"].create({"name": "ACME"})

    def test_total_se_calcula(self):
        order = self.env["sale.order"].create({"partner_id": self.partner.id})
        self.assertEqual(order.amount_total, 0.0)
```

- `tests/__init__.py` debe importar los modulos de test.
- Cada metodo `test_*` corre en su propia transaccion con rollback: datos aislados.
- `setUpClass` para datos compartidos de solo lectura; `setUp` para por-test.

## Tags

- `@tagged("post_install", "-at_install")` es lo habitual: corre tras instalar todo.
- Tags personalizados para filtrar: `--test-tags acme_sales`.
- Variable de entorno del repo: `ODOO_TEST_TAGS` (ver `.claude/settings.json`).

## Form() — emular la UI

Usa `odoo.tests.common.Form` para validar onchanges/valores por defecto como lo haria un
usuario, en vez de `create` directo:

```python
from odoo.tests.common import Form

with Form(self.env["sale.order"]) as f:
    f.partner_id = self.partner
    with f.order_line.new() as line:
        line.product_id = self.product
order = f.save()
```

## Clases base

- `TransactionCase`: la mayoria de casos (rollback por test).
- `HttpCase`: tests de controllers/tours JS (`self.url_open`, `start_tour`).
- `SavepointCase` se unifico en `TransactionCase` en versiones recientes — confirma en
  `vendor/odoo`.

## Ejecutar

```bash
odoo-bin -d test_db -i acme_sales --test-enable --test-tags acme_sales --stop-after-init
# o el lint/CI del repo:
python -m pytest   # si el proyecto lo envuelve
```

## Anti-patrones

- Depender del orden entre tests (cada uno es independiente).
- Asumir IDs fijos; usa `self.env.ref` o crea los datos.
- Tests sin asserts o que solo cubren el camino feliz.
