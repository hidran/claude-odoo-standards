#!/usr/bin/env bash
# Scaffolds un repo de cliente nuevo a partir de scaffold/.
# El estandar de empresa ya NO se copia ni se enlaza: se consume como plugin desde el
# marketplace privado. Este script deja el repo de cliente auto-enrolado en ese plugin.
#
# Uso: ./init-odoo-project.sh --client=ACME --odoo=19.0 [--edition=Community] [--python=3.12] [--deploy="odoo.sh (prod)"] [--marketplace=hidran/claude-odoo-standards]
set -euo pipefail

CLIENT=""; ODOO=""; EDITION="Community"; PYTHON="3.12"; DEPLOY="odoo.sh"
MARKETPLACE="hidran/claude-odoo-standards"
for arg in "$@"; do
  case $arg in
    --client=*)      CLIENT="${arg#*=}";;
    --odoo=*)        ODOO="${arg#*=}";;
    --edition=*)     EDITION="${arg#*=}";;
    --python=*)      PYTHON="${arg#*=}";;
    --deploy=*)      DEPLOY="${arg#*=}";;
    --marketplace=*) MARKETPLACE="${arg#*=}";;
  esac
done
[ -z "$CLIENT" ] || [ -z "$ODOO" ] && { echo "Faltan --client y --odoo"; exit 1; }

STD_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# minusculas portable (macOS trae bash 3.2; ${CLIENT,,} es de bash 4+)
CLIENT_LC="$(printf '%s' "$CLIENT" | tr '[:upper:]' '[:lower:]')"
DEST="../${CLIENT_LC}-odoo${ODOO%%.*}"
mkdir -p "$DEST"
cp -r "$STD_DIR/scaffold/." "$DEST/"

# Rellena la plantilla del overlay (CLAUDE.md thin: solo VERSION LOCK + quirks)
sed -e "s|{{CLIENT}}|$CLIENT|g" \
    -e "s|{{ODOO_VERSION}}|$ODOO|g" \
    -e "s|{{EDITION}}|$EDITION|g" \
    -e "s|{{PYTHON}}|$PYTHON|g" \
    -e "s|{{DEPLOY}}|$DEPLOY|g" \
    "$DEST/CLAUDE.md.tmpl" > "$DEST/CLAUDE.md"
rm "$DEST/CLAUDE.md.tmpl"

# Rellena el settings.json para auto-enrolar el plugin del marketplace de empresa
sed -e "s|{{MARKETPLACE}}|$MARKETPLACE|g" \
    "$DEST/.claude/settings.json.tmpl" > "$DEST/.claude/settings.json"
rm "$DEST/.claude/settings.json.tmpl"

cd "$DEST"
git init -q
git submodule add -q -b "$ODOO" https://github.com/odoo/odoo.git vendor/odoo || \
  echo "NOTA: anade manualmente el submodulo de Odoo $ODOO en vendor/odoo"

cat <<EOF
Repo de cliente listo en: $DEST (Odoo $ODOO)

El repo ya queda auto-enrolado en el plugin de empresa via .claude/settings.json.
Al abrir 'claude' en ese repo se cargara el marketplace '$MARKETPLACE' y el plugin
'odoo-standards' (skills, commands, agents, hooks).

Si tu Claude Code aun no conoce el marketplace, una sola vez:
  /plugin marketplace add $MARKETPLACE
EOF
