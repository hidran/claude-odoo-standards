# Estándar Odoo como plugin de Claude Code (marketplace privado)

Muestra cómo una consultora Odoo multi-versión centraliza su estándar de ingeniería con
el modelo nativo de Claude Code: **un plugin versionado servido desde un marketplace
privado**, en vez de symlinks o `@import`.

```
claude-odoo-standards/            # marketplace (este repo)
├── .claude-plugin/marketplace.json
├── plugins/odoo-standards/       # el plugin: skills, commands, agents, hooks
├── scaffold/ + scripts/          # generador de repos de cliente thin
└── acme-erp-odoo19/              # repo de CLIENTE de ejemplo (Odoo 19)
```

> En producción serían **dos repos** en tu organización: `tu-org/claude-odoo-standards`
> (este) y `tu-org/acme-erp-odoo19`. Aquí van juntos solo para el ejemplo.

## El plugin `odoo-standards`

Entrega el estándar de empresa de forma nativa:

- **Skills** — `odoo-engineering-standard` (reglas de oro, SOLID/seguridad),
  `odoo-version-guardrails` (matriz v14→v19; aplica solo la columna del VERSION LOCK),
  `verify-multi-company`.
- **Commands** — `/new-module`, `/migrate-check`, `/fix-ticket`, `/gen-i18n`.
- **Agents** — `odoo-version-auditor`, `odoo-security-reviewer`, `odoo-enterprise-auditor`.
- **Hooks** — guard de secretos (PreToolUse) y lint Odoo (PostToolUse).

## Cómo se usa

**Repo existente** (opt-in manual, una vez):

```bash
/plugin marketplace add hidran/claude-odoo-standards
/plugin install odoo-standards@claude-odoo-standards
```

**Repo de cliente nuevo** (auto-enrolado):

```bash
cd claude-odoo-standards
./scripts/init-odoo-project.sh --client=ACME --odoo=19.0 --edition=Community --python=3.12
```

Genera `../acme-odoo19/` con un `CLAUDE.md` thin (solo `🔒 VERSION LOCK`) y un
`.claude/settings.json` que enrola el marketplace + plugin. Al abrir `claude` en ese
repo, el estándar completo se carga desde el plugin.

## Enterprise (enforcement opcional)

`managed/` documenta cómo IT fija el marketplace y `enabledPlugins` vía managed-settings
(MDM/Jamf/Intune) para enrolamiento no sobrescribible. Ver `docs/plan-rollout.md`.

## Plugins de terceros (Letzdoo)

`marketplace.json` agrega `odoo-development`, `odoo-query` y `odoo-token-killer` para un
único punto de alta. **Confirma los repos reales** de esos plugins antes de instalarlos.

> Los `rev:`/versiones de pre-commit y los precios de Claude conviene verificarlos
> contra las fuentes oficiales vigentes antes de adoptarlos.
