#!/usr/bin/env bash
# Bloquea comandos Bash que expongan secretos. Recibe el JSON del evento por stdin.
set -euo pipefail
payload="$(cat)"
cmd="$(printf '%s' "$payload" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null || true)"
if printf '%s' "$cmd" | grep -Eiq '(\.env|id_rsa|AKIA[0-9A-Z]{16}|password=|secret=)'; then
  echo "BLOQUEADO: el comando referencia un posible secreto." >&2
  exit 2   # exit 2 = bloquea la herramienta en Claude Code
fi
exit 0
