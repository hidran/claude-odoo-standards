# Project Integration Script Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create an interactive Bash script `install-to-project.sh` that allows developers to easily integrate Claude standards into existing Odoo projects.

**Architecture:** A standalone Bash script that detects the parent project, presents an interactive menu, and performs idempotent file modifications (symlinking, `@import` injection).

**Tech Stack:** Bash.

---

### Task 1: Create Base Script & Project Detection

**Files:**
- Create: `claude-standards/scripts/install-to-project.sh`

- [ ] **Step 1: Write initial script structure**
Implement basic project detection and root path resolution.

```bash
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
```

- [ ] **Step 2: Commit**
`git add claude-standards/scripts/install-to-project.sh && git commit -m "feat: initial install-to-project.sh script"`

---

### Task 2: Implement CLAUDE.md Integration

**Files:**
- Modify: `claude-standards/scripts/install-to-project.sh`

- [ ] **Step 1: Add CLAUDE.md setup logic**
Implement the function to create or update `CLAUDE.md` with the `@import` directive.

```bash
setup_claude_md() {
    local target="$PROJECT_ROOT/CLAUDE.md"
    local import_line="@import ./$STD_REL_PATH/CLAUDE.md"

    if [ ! -f "$target" ]; then
        echo "Creando CLAUDE.md..."
        echo -e "# Proyecto Odoo\n\n$import_line\n" > "$target"
    elif ! grep -q "$import_line" "$target"; then
        echo "Añadiendo importación a CLAUDE.md..."
        # Insert at top
        sed -i "1i $import_line\n" "$target"
    else
        echo "CLAUDE.md ya contiene la importación."
    fi
}
```

- [ ] **Step 2: Commit**
`git add claude-standards/scripts/install-to-project.sh && git commit -m "feat: add CLAUDE.md integration to installer"`

---

### Task 3: Implement Agents/Commands Symlinking

**Files:**
- Modify: `claude-standards/scripts/install-to-project.sh`

- [ ] **Step 1: Add symlinking logic**
Implement functions to link agents and commands to the project's `.claude/` folder.

```bash
setup_agents() {
    mkdir -p "$PROJECT_ROOT/.claude/agents"
    echo "Enlazando agentes..."
    for agent in "$STD_DIR/.claude/agents"/*.md; do
        ln -sfn "../../$STD_REL_PATH/.claude/agents/$(basename "$agent")" "$PROJECT_ROOT/.claude/agents/"
    done
}

setup_commands() {
    mkdir -p "$PROJECT_ROOT/.claude/commands"
    echo "Enlazando comandos..."
    for cmd in "$STD_DIR/.claude/commands"/*.md; do
        ln -sfn "../../$STD_REL_PATH/.claude/commands/$(basename "$cmd")" "$PROJECT_ROOT/.claude/commands/"
    done
}
```

- [ ] **Step 2: Commit**
`git add claude-standards/scripts/install-to-project.sh && git commit -m "feat: add agents/commands symlinking to installer"`

---

### Task 4: Implement Interactive Menu

**Files:**
- Modify: `claude-standards/scripts/install-to-project.sh`

- [ ] **Step 1: Add main menu loop**
Combine all functions into an interactive menu.

```bash
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
```

- [ ] **Step 2: Make executable & Commit**
`chmod +x claude-standards/scripts/install-to-project.sh && git add claude-standards/scripts/install-to-project.sh && git commit -m "feat: finalize interactive installer"`

---

### Task 5: Update Documentation

**Files:**
- Modify: `claude-standards/README.md`

- [ ] **Step 1: Add integration instructions**
Update the README to explain how to use the new script.

```markdown
## Integración en proyectos existentes

Si ya tienes un proyecto Odoo y quieres adoptar estos estándares:

1. Clona este repo dentro de tu proyecto:
   `git clone https://github.com/hidran/claude-odoo-standards claude-standards`
2. Ejecuta el instalador interactivo:
   `./claude-standards/scripts/install-to-project.sh`
3. Sigue las instrucciones para enlazar agentes y configurar tu `CLAUDE.md`.
```

- [ ] **Step 2: Commit**
`git add claude-standards/README.md && git commit -m "docs: update README with integration instructions"`
