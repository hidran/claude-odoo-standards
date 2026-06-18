---
name: verify-multi-company
description: Use when validating that an Odoo development complies with multi-company isolation standards.
---

# Skill: Verificar Multi-Compania

Guia para validar que un desarrollo cumple con los estandares de aislamiento de Odoo Enterprise.

## Procedimiento

1. **Identificar Modelos:** Listar todos los modelos nuevos o modificados en el PR.
2. **Chequeo de `company_id`:**
   - Tienen campo `company_id`?
   - Es `required=True`?
   - Tiene `default=lambda self: self.env.company`?
3. **Validacion de XML:**
   - Grep de `ir.rule` en los archivos de seguridad.
   - Confirmar uso de `company_ids` en el dominio.
4. **Auditoria Automatizada:**
   - Invocar al agente `odoo-enterprise-auditor` sobre el diff de la rama.
5. **Prueba de Fuego:**
   - Verificar que un usuario con acceso a la Compania A no pueda ver registros de la
     Compania B, incluso mediante campos relacionales.
