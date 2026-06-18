---
name: odoo-views-qweb
description: Vistas XML y plantillas QWeb de Odoo — estructura de form/list/search/kanban, herencia de vistas con xpath y position, y reportes QWeb PDF. Usalo al crear o editar views/*.xml o report/*.xml. Para el tag raiz correcto por version (<list> vs <tree>, attrs inline) usa la skill odoo-version-guardrails.
---

# Vistas XML y QWeb

> El tag raiz y los atributos cambian por version. Antes de tocar XML, aplica la skill
> `odoo-version-guardrails` con el VERSION LOCK del repo.

## Tipos de vista

- **form**: `<sheet>`, `<group>`, `<notebook>`/`<page>`, botones en `<header>`.
- **list** (18/19) / **tree** (<=17): columnas; `decoration-*` para color por estado.
- **search**: `<field>`, `<filter>`, `<group>` (groupby), `<searchpanel>`.
- **kanban**: tarjetas con QWeb inline (`<t t-...>`).

La accion (`ir.actions.act_window`) usa `view_mode` con la sintaxis de la version
(`list,form` en 18/19; `tree,form` en <=17).

## Herencia de vistas (extender, no reescribir)

```xml
<record id="view_sale_form_acme" model="ir.ui.view">
    <field name="name">sale.order.form.acme</field>
    <field name="model">sale.order</field>
    <field name="inherit_id" ref="sale.view_order_form"/>
    <field name="arch" type="xml">
        <xpath expr="//field[@name='partner_id']" position="after">
            <field name="x_acme_ref"/>
        </xpath>
    </field>
</record>
```

- `position`: `after`, `before`, `inside`, `replace`, `attributes`.
- Localiza el nodo con el xpath mas estable posible (por `name`, no por indice).
- Nunca edites la vista del core: hereda.

## Reportes QWeb (PDF)

- Define `ir.actions.report` + una plantilla QWeb (`<template>` con
  `<t t-call="web.external_layout">`).
- Itera con `t-foreach`, imprime con `t-field`/`t-esc`, formatea con widgets y
  `t-options`.
- Carga el `report/*.xml` en `data` del manifest.

## Seguridad de UI

- Visibilidad por grupo: `groups="module.group_xmlid"` en el nodo.
- Visibilidad condicional: atributos inline (`invisible="state == 'done'"`) segun version
  — ver `odoo-version-guardrails`.

## Anti-patrones

- xpath fragiles por posicion (`//field[3]`).
- Duplicar una vista entera en vez de heredar.
- Logica de negocio en onchange de la vista en vez de compute/constrains.
