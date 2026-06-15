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
