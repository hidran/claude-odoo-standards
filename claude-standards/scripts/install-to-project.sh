#!/usr/bin/env bash
set -euo pipefail

# Find project root (parent of the standards directory)
STD_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_ROOT="$(cd "$STD_DIR/.." && pwd)"
STD_REL_PATH="$(basename "$STD_DIR")"

echo "Directorio de estándares: $STD_DIR"
echo "Raíz del proyecto: $PROJECT_ROOT"

if [ "$STD_DIR" == "$PROJECT_ROOT" ]; then
    echo "ERROR: Ejecuta este script desde dentro de un proyecto Odoo donde hayas clonado este repo."
    exit 1
fi

setup_claude_md() {
    local target="$PROJECT_ROOT/CLAUDE.md"
    local import_line="@import ./$STD_REL_PATH/CLAUDE.md"

    if [ ! -f "$target" ]; then
        echo "Creando CLAUDE.md..."
        echo -e "# Proyecto Odoo\n\n$import_line\n" > "$target"
    elif ! grep -q "$import_line" "$target"; then
        echo "Añadiendo importación a CLAUDE.md..."
        # Insert at top
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "1i\\
$import_line\\
" "$target"
        else
            sed -i "1i $import_line\n" "$target"
        fi
    else
        echo "CLAUDE.md ya contiene la importación."
    fi
}
