# Ejemplo: estándar de empresa + repo de cliente (Odoo 19)

Dos repos que muestran cómo organizar Claude Code en un shop Odoo multi-versión.

```
odoo-claude-example/
├── claude-standards/      # 1) Estándar EMPRESARIAL (fuente de verdad, agnóstico de versión)
└── acme-erp-odoo19/       # 2) Repo de CLIENTE de ejemplo, fija Odoo 19.0 e importa el estándar
```

## 1) claude-standards (empresa)
Política de seguridad NO sobrescribible (`managed/`), estándar de ingeniería (`CLAUDE.md`),
slash commands y subagentes compartidos, hooks, la **matriz de versiones v14→v19**
(`docs/odoo-version-guardrails.md`), y el scaffolder de repos nuevos (`scripts/`).

## 2) acme-erp-odoo19 (cliente / usuario)
Importa el estándar y añade su **🔒 VERSION LOCK 19.0**. El módulo `acme_sales` usa la
sintaxis CORRECTA de Odoo 19: `<list>`, atributos inline, `_compute_display_name()`,
`from odoo import Command`, `view_mode="list,form"`.

## En la práctica (GitHub)
Serían **dos repos separados** en tu organización de GitHub:
`tu-org/claude-standards` y `tu-org/acme-erp-odoo19`. El segundo trae el primero como
submódulo (o por path en monorepo). Para subirlos:

```bash
# repo de estándares
cd claude-standards && git init && git add . && git commit -m "init: estándar de empresa"
gh repo create tu-org/claude-standards --private --source=. --push

# repo de cliente
cd ../acme-erp-odoo19 && git init && git add . && git commit -m "init: ACME Odoo 19"
gh repo create tu-org/acme-erp-odoo19 --private --source=. --push
```

> Los `rev:`/versiones de pre-commit y los precios de Claude conviene verificarlos
> contra las fuentes oficiales vigentes antes de adoptarlos.
