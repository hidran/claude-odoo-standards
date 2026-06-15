#!/usr/bin/env bash
# Scaffolds un repo de cliente nuevo a partir de claude-standards/scaffold.
# Uso: ./init-odoo-project.sh --client=ACME --odoo=19.0 [--edition=Community] [--python=3.12] [--deploy="odoo.sh (prod)"]
set -euo pipefail

CLIENT=""; ODOO=""; EDITION="Community"; PYTHON="3.12"; DEPLOY="odoo.sh"
for arg in "$@"; do
  case $arg in
    --client=*)  CLIENT="${arg#*=}";;
    --odoo=*)    ODOO="${arg#*=}";;
    --edition=*) EDITION="${arg#*=}";;
    --python=*)  PYTHON="${arg#*=}";;
    --deploy=*)  DEPLOY="${arg#*=}";;
  esac
done
[ -z "$CLIENT" ] || [ -z "$ODOO" ] && { echo "Faltan --client y --odoo"; exit 1; }

STD_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# minúsculas portable (macOS trae bash 3.2; ${CLIENT,,} es de bash 4+)
CLIENT_LC="$(printf '%s' "$CLIENT" | tr '[:upper:]' '[:lower:]')"
DEST="../${CLIENT_LC}-odoo${ODOO%%.*}"
mkdir -p "$DEST"
cp -r "$STD_DIR/scaffold/." "$DEST/"

# Rellena la plantilla del overlay
sed -e "s|{{CLIENT}}|$CLIENT|g" \
    -e "s|{{ODOO_VERSION}}|$ODOO|g" \
    -e "s|{{EDITION}}|$EDITION|g" \
    -e "s|{{PYTHON}}|$PYTHON|g" \
    -e "s|{{DEPLOY}}|$DEPLOY|g" \
    -e "s|{{STANDARDS_PATH}}|../claude-standards|g" \
    "$DEST/CLAUDE.md.tmpl" > "$DEST/CLAUDE.md"
rm "$DEST/CLAUDE.md.tmpl"

cd "$DEST"
git init -q
git submodule add -q -b "$ODOO" https://github.com/odoo/odoo.git vendor/odoo || \
  echo "NOTA: añade manualmente el submódulo de Odoo $ODOO en vendor/odoo"
echo "Repo de cliente listo en: $DEST (Odoo $ODOO)"
