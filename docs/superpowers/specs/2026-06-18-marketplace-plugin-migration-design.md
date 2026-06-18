# Diseño: distribuir el estándar Odoo como plugin + marketplace

> Fecha: 2026-06-18
> Estado: aprobado, en implementación

## Problema

El estándar de empresa se distribuía con tres mecanismos frágiles y solapados:

- `@import` en los `CLAUDE.md` de cliente — **sintaxis incorrecta** de Claude Code
  (la directiva real es `@ruta`, sin la palabra `import`), así que probablemente el
  estándar nunca se cargaba.
- Dos instaladores que se contradecían: `sync-standards.sh` (symlinks **globales** a
  `~/.claude/`) vs `install-to-project.sh` (symlinks **por proyecto** a `.claude/`),
  con desacuerdo sibling-vs-nested sobre dónde vive el estándar.
- El estándar canónico estaba **duplicado** (copia en la raíz vs clon anidado
  `claude-standards/`) y ya había divergido.

## Decisión

Replicar el modelo nativo que usan las organizaciones grandes: **un plugin de Claude
Code versionado, servido desde un marketplace privado.** Decisiones tomadas en el
brainstorm:

1. **Alcance:** plugin + marketplace completo (retirar los instaladores symlink).
2. **Versionado Odoo:** un solo plugin; el `🔒 VERSION LOCK` del repo de cliente
   selecciona la columna v14→v19 a aplicar.
3. **Enrolamiento:** opt-in a nivel usuario/proyecto (sin MDM); el scaffolder escribe
   `.claude/settings.json` con `extraKnownMarketplaces` + `enabledPlugins` para que un
   `git clone` quede auto-enrolado.
4. **Plugins externos (Letzdoo):** agregados en el mismo marketplace, un solo punto de
   alta.

## Arquitectura

El repo `claude-odoo-standards` deja de ser fuente de symlinks y pasa a ser un
**marketplace** que aloja un plugin:

```
claude-odoo-standards/
├── .claude-plugin/marketplace.json     # nuestro plugin + plugins Letzdoo
├── plugins/odoo-standards/
│   ├── .claude-plugin/plugin.json
│   ├── skills/
│   │   ├── odoo-engineering-standard/   # estándar agnóstico (reglas de oro)
│   │   ├── odoo-version-guardrails/     # matriz v14→v19 (todas las columnas)
│   │   └── verify-multi-company/        # validación aislamiento multi-compañía
│   ├── commands/                        # new-module, migrate-check, fix-ticket, gen-i18n
│   ├── agents/                          # version-auditor, security-reviewer, enterprise-auditor
│   └── hooks/
│       ├── hooks.json                   # PreToolUse + PostToolUse
│       └── scripts/                     # secret-scan-guard.sh, run-odoo-lint.sh
├── scaffold/                            # plantilla de repo de cliente nuevo
├── scripts/init-odoo-project.sh         # genera cliente thin + auto-enrol
├── managed/                             # docs de la vía de enforcement opcional (MDM)
└── docs/
```

### Cómo se entrega el estándar (el cambio clave)

Los plugins de Claude Code no inyectan de forma fiable un `CLAUDE.md` en cada sesión,
pero **sí distribuyen skills de forma nativa** (es como Anthropic publica superpowers).
Por eso el estándar se reparte según su uso:

- **Siempre-activo y corto → `CLAUDE.md` thin del repo de cliente**, que el scaffolder
  escribe: solo el `🔒 VERSION LOCK` (lo único que el plugin no puede saber, es
  específico del cliente) + "fuente de verdad = `vendor/odoo`".
- **Estándar agnóstico → skill `odoo-engineering-standard`** (reglas de oro, SOLID/DRY,
  compuertas de calidad, seguridad default-deny, multi-compañía). Se dispara en trabajo
  de módulos Odoo.
- **Matriz v14→v19 → skill `odoo-version-guardrails`** — contiene todas las columnas e
  instruye a Claude a leer el VERSION LOCK del repo y aplicar **solo** esa columna.

Esto elimina el bug de `@import` y las referencias frágiles a rutas de plugin.

### Enrolamiento (opt-in)

- **Repo existente:** `/plugin marketplace add hidran/claude-odoo-standards` →
  `/plugin install odoo-standards@claude-odoo-standards`.
- **Repo nuevo:** `init-odoo-project.sh` escribe `.claude/settings.json` con
  `extraKnownMarketplaces` + `enabledPlugins`; quien clona queda auto-enrolado al
  primer `claude`. Sin dependencia de MDM.

## Qué se retira

- `scripts/sync-standards.sh`, `install-to-project.sh`, y el `@import` de
  `scaffold/CLAUDE.md.tmpl`.
- El clon anidado `claude-standards/` y la duplicación raíz del estándar → única fuente
  en `plugins/odoo-standards/skills/`.
- `acme-erp-odoo19` se regenera como cliente thin (VERSION LOCK + settings.json) para
  demostrar el modelo nuevo, conservando el módulo `acme_sales` como ejemplo de
  sintaxis v19 correcta.
- `managed/` se conserva como documentación de la vía de enforcement opcional.

## Resultado

Un repo de cliente queda en ~10 líneas de `CLAUDE.md` + un `settings.json`, y hereda
commands/agents/skills/hooks/reglas-de-versión de un único plugin versionado.
