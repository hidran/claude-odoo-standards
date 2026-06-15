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

setup_agents() {
    mkdir -p "$PROJECT_ROOT/.claude/agents"
    echo "Enlazando agentes..."
    for agent in "$STD_DIR/.claude/agents"/*.md; do
        [ -e "$agent" ] || continue
        ln -sfn "../../$STD_REL_PATH/.claude/agents/$(basename "$agent")" "$PROJECT_ROOT/.claude/agents/"
    done
}

setup_commands() {
    mkdir -p "$PROJECT_ROOT/.claude/commands"
    echo "Enlazando comandos..."
    for cmd in "$STD_DIR/.claude/commands"/*.md; do
        [ -e "$cmd" ] || continue
        ln -sfn "../../$STD_REL_PATH/.claude/commands/$(basename "$cmd")" "$PROJECT_ROOT/.claude/commands/"
    done
}

# Menú interactivo
echo "=== Instalador de Estándares Claude ==="
PS3='Selecciona una opción: '
options=("Configurar CLAUDE.md" "Enlazar Agentes y Comandos" "Todo" "Salir")
select opt in "${options[@]}"
do
    case $opt in
        "Configurar CLAUDE.md")
            setup_claude_md
            ;;
        "Enlazar Agentes y Comandos")
            setup_agents
            setup_commands
            ;;
        "Todo")
            setup_claude_md
            setup_agents
            setup_commands
            ;;
        "Salir")
            break
            ;;
        *) echo "Opción inválida $REPLY";;
    esac
done

echo "Instalación completada correctamente."
