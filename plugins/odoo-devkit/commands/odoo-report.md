---
description: Genera un reporte QWeb PDF (accion + plantilla) para un modelo
---
Crea un reporte QWeb PDF para el modelo `$1`.

Aplica la skill `odoo-views-qweb`:
1. `report/<archivo>_report.xml`: `ir.actions.report` (`report_type="qweb-pdf"`,
   `report_name`, `binding_model_id` para que aparezca en el menu Imprimir).
2. `report/<archivo>_templates.xml`: `<template>` que use
   `t-call="web.external_layout"`, itere los `docs` con `t-foreach` e imprima con
   `t-field`/`t-esc` y widgets de formato.
3. Carga ambos XML en `data` del `__manifest__.py`.
4. Da accesos si el reporte usa un modelo auxiliar.

Verifica los nombres de layout/helpers en `vendor/odoo` de la version fijada (cambian
entre releases). Diff minimo.
