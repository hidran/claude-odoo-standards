#!/usr/bin/env bash
# Enlaza commands y agents compartidos a ~/.claude para que estén disponibles globalmente.
set -euo pipefail
STD_DIR="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$HOME/.claude/commands" "$HOME/.claude/agents"
ln -sfn "$STD_DIR/.claude/commands"/* "$HOME/.claude/commands/" 2>/dev/null || true
ln -sfn "$STD_DIR/.claude/agents"/*  "$HOME/.claude/agents/"  2>/dev/null || true
echo "Commands y agents de empresa enlazados en ~/.claude/"
