# managed/ — política NO sobrescribible

Estos archivos los despliega **IT**, no el desarrollador. Son el piso de seguridad e IP:
ningún `settings.json` de usuario o proyecto puede revertirlos.

## Precedencia (de mayor a menor)
`managed settings` > flags de CLI > `.claude/settings.local.json` > `.claude/settings.json` > `~/.claude/settings.json`

> Lo *managed* gana siempre. Si aquí se deniega `Bash(curl:*)`, no hay forma de habilitarlo desde el proyecto.

## Dónde se colocan (ruta gestionada del SO)
- **macOS:** `/Library/Application Support/ClaudeCode/managed-settings.json`
- **Linux:** `/etc/claude-code/managed-settings.json`
- **Windows:** `C:\ProgramData\ClaudeCode\managed-settings.json`

(El MCP gestionado va junto, como `managed-mcp.json`.)

> Confirma las rutas exactas para tu versión de Claude Code en
> https://code.claude.com/docs/en/settings — pueden variar entre releases.
