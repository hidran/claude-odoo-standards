# Plan de despliegue de Claude Code en [Empresa]

## Fase 0 — Piloto (semanas 1-4)
- 2-3 asientos **Max 20x** para champions. Sin estructura todavía: aprender límites y flujos.
- Elegir 1 repo de cliente real de cada extremo (un v14 y un v19) como banco de pruebas.

## Fase 1 — Estandarización (semanas 5-8)
- Mover a **Team Premium** (mín. 5 asientos, incluye Claude Code) + consola de admin.
- Publicar este repo `claude-standards`. Cada dev corre `scripts/sync-standards.sh`.
- IT despliega `managed/` (piso de seguridad e IP).

## Fase 2 — Enforcement y escala
- Pasar a **Enterprise** cuando se necesite: managed-settings obligatorio, SSO/SCIM,
  audit logs, data residency (clientes LatAm/Cuba), contexto 500K.
- API key aparte para CI/headless en odoo.sh y GitHub Actions.

## Métricas de ROI
- PR cycle time, tiempo de resolución de tickets, tendencia de cobertura de tests,
  time-to-first-PR de un módulo nuevo.

> Precios y términos cambian: confirmar en anthropic.com/pricing y la Console.
> Ojo: el asiento Enterprise base no incluye uso (se factura a tarifa API encima).
