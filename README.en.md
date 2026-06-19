# Odoo standard as a Claude Code plugin (private marketplace)

> Languages: **English** · [Español](README.md)

Shows how a multi-version Odoo consultancy centralizes its engineering standard with the
native Claude Code model: **a versioned plugin served from a private marketplace**,
instead of symlinks or `@import`.

```
claude-odoo-standards/            # marketplace (this repo)
├── .claude-plugin/marketplace.json
├── plugins/odoo-standards/       # the plugin: skills, commands, agents, hooks
├── scaffold/ + scripts/          # generator for thin client repos
└── acme-erp-odoo19/              # example CLIENT repo (Odoo 19)
```

> In production these would be **two repos** in your org: `your-org/claude-odoo-standards`
> (this one) and `your-org/acme-erp-odoo19`. They live together here only for the example.

## The plugins

**`odoo-standards`** — the company standard, delivered natively:

- **Skills** — `odoo-engineering-standard` (golden rules, SOLID/security),
  `odoo-version-guardrails` (v14→v19 matrix; applies only the VERSION LOCK column),
  `odoo-orm-patterns`, `odoo-testing`, `odoo-performance`, `odoo-views-qweb`,
  `odoo-migrations`, `verify-multi-company`.
- **Commands** — `/new-module`, `/migrate-check`, `/fix-ticket`, `/gen-i18n`.
- **Agents** — `odoo-version-auditor`, `odoo-security-reviewer`, `odoo-enterprise-auditor`.
- **Hooks** — secret-scan guard (PreToolUse) and Odoo lint (PostToolUse).

**`odoo-devkit`** — scaffolding that applies the skills above:

- **Commands** — `/odoo-model`, `/odoo-field`, `/odoo-wizard`, `/odoo-report`,
  `/odoo-controller`, `/odoo-cron`.
- **Agents** — `odoo-perf-auditor` (N+1 / compute / index anti-patterns).

## How it's used

**Existing repo** (manual opt-in, once):

```bash
/plugin marketplace add hidran/claude-odoo-standards
/plugin install odoo-standards@claude-odoo-standards
```

**New client repo** (auto-enrolled):

```bash
cd claude-odoo-standards
./scripts/init-odoo-project.sh --client=ACME --odoo=19.0 --edition=Community --python=3.12
```

Generates `../acme-odoo19/` with a thin `CLAUDE.md` (only the `🔒 VERSION LOCK`) and a
`.claude/settings.json` that enrolls the marketplace + plugin. When you open `claude` in
that repo, the full standard loads from the plugin.

## Enterprise (optional enforcement)

`managed/` documents how IT pins the marketplace and `enabledPlugins` via managed-settings
(MDM/Jamf/Intune) for non-overridable enrollment. See `docs/plan-rollout.md`.

## Third-party plugins (Letzdoo)

`marketplace.json` aggregates `odoo-development`, `odoo-query`, and `odoo-token-killer` for
a single point of entry. **Confirm the real repos** of those plugins before installing.

> The pre-commit `rev:`/versions and Claude pricing should be verified against the current
> official sources before adopting them.
