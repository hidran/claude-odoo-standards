---
name: odoo-migrations
description: Scripts de migracion de datos/esquema en Odoo — carpeta migrations/<version>/ con pre-/post-/end-, uso de openupgradelib, idempotencia y seguridad de datos. Usalo cuando un cambio altere el esquema (renombrar/eliminar campos o modelos, mover datos) en un sistema con datos existentes.
---

# Migraciones en Odoo

> Si cambias el esquema sobre datos en vivo, necesitas script de migracion. Confirma la
> version del repo (VERSION LOCK) y prueba sobre una copia de la BD antes de produccion.

## Estructura

```
mi_modulo/
└── migrations/
    └── 18.0.1.1.0/                  # = nueva version del modulo en __manifest__
        ├── pre-migrate.py           # antes de cargar el nuevo esquema
        ├── post-migrate.py          # despues de cargar esquema/datos
        └── end-migrate.py           # al final de TODA la actualizacion
```

- Sube la `version` en `__manifest__.py`; Odoo ejecuta los scripts de la carpeta que
  coincide al actualizar (`-u modulo`).
- **pre**: ajustar columnas/datos antes de que el ORM cargue el nuevo modelo
  (p.ej. renombrar columna para no perder datos).
- **post**: rellenar/transformar datos con el nuevo esquema ya disponible.

## Firma del script

```python
def migrate(cr, version):
    if not version:
        return
    cr.execute("ALTER TABLE acme_sample RENAME COLUMN old_name TO new_name")
```

- Recibes el cursor `cr` (SQL crudo) y la `version` previa.
- Para operaciones de ORM, instancia un Environment desde `cr` (mira ejemplos en
  `vendor/odoo`/OCA para tu version).

## openupgradelib

Para renombrados/movimientos comunes, `openupgradelib` ofrece helpers
(`rename_columns`, `rename_models`, `move_field_*`). Anadelo a `requirements` si lo usas y
verifica compatibilidad con la version.

## Reglas

- **Idempotencia**: el script debe poder re-ejecutarse sin romper (usa `IF EXISTS`,
  comprueba antes de actuar).
- **No pierdas datos**: renombra columnas en `pre` en lugar de dejar que el ORM borre y
  recree.
- **SQL crudo con cuidado**: parametriza, nunca interpoles input de usuario.
- **Prueba**: corre la actualizacion sobre un dump real de staging y valida conteos
  antes/despues.

## Relacion con el flujo

En soporte (`/fix-ticket`), si el ticket cambia el esquema, el script de `migrations/` es
parte del mismo PR que el cambio de modelo.
