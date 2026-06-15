# claude-standards

Fuente de verdad **única** para el uso de Claude Code en desarrollo Odoo de [Empresa].
Todo dev y todo repo de cliente deriva de aquí. No se copia a mano: se distribuye y se versiona.

## Qué hay aquí

| Ruta | Qué es | Quién lo aplica |
|------|--------|-----------------|
| `CLAUDE.md` | Estándar de ingeniería **agnóstico de versión** (SOLID, estructura de módulo, calidad, git, seguridad) | Todos los repos, vía `@import` |
| `managed/` | Política **NO sobrescribible** (seguridad e IP). La despliega IT, no el dev | Máquina de cada dev |
| `.claude/commands/` | Slash commands compartidos (`/new-module`, `/fix-ticket`, `/migrate-check`, `/gen-i18n`) | Todos |
| `.claude/agents/` | Subagentes (auditor de versión, revisor de seguridad) | Todos |
| `hooks/` | Scripts de hook (secret-scan, lint) | Vía managed o proyecto |
| `scaffold/` | Plantilla que `init-odoo-project.sh` deja en cada repo nuevo | Repos nuevos |
| `scripts/` | `init-odoo-project.sh`, `sync-standards.sh` | Devs y leads |
| `docs/odoo-version-guardrails.md` | Matriz de cambios v14 → v19 (la pieza clave) | Referencia |

## Modelo mental

```
Estándar de empresa (este repo, agnóstico de versión)
        │  @import
        ▼
Overlay de cliente (CLAUDE.md del repo del cliente) + 🔒 VERSION LOCK
        │
        ▼
Código generado, validado contra el fuente real de ESA versión
```

## Distribución (resumen)

1. IT despliega `managed/managed-settings.json` y `managed/managed-mcp.json` en la ruta gestionada del SO de cada dev (ver `managed/README.md`). Esto es el **piso de seguridad**: ningún dev lo puede saltar.
2. Cada dev clona este repo y corre `scripts/sync-standards.sh` para enlazar commands/agents a `~/.claude/`.
3. Para un cliente nuevo: `scripts/init-odoo-project.sh --client=ACME --odoo=19.0`.

> Verifica siempre claves y precedencia exactas en la doc oficial vigente:
> https://code.claude.com/docs/en/settings — cambian entre versiones de Claude Code.
