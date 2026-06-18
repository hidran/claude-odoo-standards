---
description: Genera un controller HTTP/website con validacion de input y auth correcta
---
Crea un controller `$1` en `controllers/`.

Seguridad primero (skill `odoo-engineering-standard` seccion 4):
1. `controllers/<archivo>.py`: clase heredando `http.Controller`, rutas con
   `@http.route(..., type=..., auth=...)`. Elige `auth` deliberadamente:
   `user` (sesion), `public` (anonimo, valida TODO), `none` (sin sesion).
2. **Valida y sanea** cada parametro de entrada. Nunca confies en datos del request.
3. `sudo()` solo si es imprescindible y con comentario justificativo; filtra por
   `company_id`/`website_id` donde aplique.
4. `csrf=True` para formularios POST de website.
5. Registra `controllers/__init__.py` y el import en el modulo.
6. Test con `HttpCase` (`self.url_open`).

Verifica firmas de `http`/`request` en `vendor/odoo`. No expongas datos de otra compania.
