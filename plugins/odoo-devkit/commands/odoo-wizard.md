---
description: Genera un wizard (TransientModel) con su vista de formulario y accion
---
Crea un wizard `$1` (p.ej. `acme.import.wizard`) en `wizards/`.

1. `wizards/<archivo>.py`: clase heredando `models.TransientModel`, campos de entrada y
   un metodo de accion (p.ej. `action_confirm`) que devuelve una `ir.actions.*` o
   `{'type': 'ir.actions.act_window_close'}`.
2. Vista form del wizard con `<footer>` y botones (`special="cancel"`).
3. Accion `ir.actions.act_window` con `target="new"` (dialogo modal).
4. `security/ir.model.access.csv`: acceso al TransientModel para los grupos que lo usan.
5. Registra imports y carga el XML en `__manifest__.py`.
6. Test minimo que ejecute el metodo de accion.

Respeta el VERSION LOCK (sintaxis de vistas) y los patrones del ORM. Verifica en
`vendor/odoo` cualquier firma dudosa.
