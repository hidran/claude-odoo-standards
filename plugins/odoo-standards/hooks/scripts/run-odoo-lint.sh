#!/usr/bin/env bash
# Lint tras editar/escribir. No bloquea el flujo; solo informa.
set -uo pipefail
if command -v pre-commit >/dev/null 2>&1; then
  pre-commit run --files "$(git diff --name-only 2>/dev/null)" || true
fi
exit 0
