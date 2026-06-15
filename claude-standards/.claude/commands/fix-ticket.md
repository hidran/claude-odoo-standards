---
description: Flujo de soporte para un ticket sobre un sistema en vivo
---
Resuelve el ticket: $ARGUMENTS

Reglas:
1. Confirma la versión Odoo del repo (VERSION LOCK) antes de nada.
2. REPRODUCE primero: escribe un test que falle o documenta pasos de repro.
3. Diff mínimo, respetando `_inherit`. No reescribas módulos.
4. Si tocas esquema (campos/modelos) → script de migración en `migrations/`.
5. Corre el subagente `odoo-version-auditor` y los tests antes de proponer el PR.
