# Design Spec: Project Integration Script (`install-to-project.sh`)

**Date:** 2026-06-15  
**Topic:** Claude Standards Integration for Existing Projects  
**Status:** Draft

## 1. Purpose
Enable developers who have cloned the `claude-standards` repository as a subdirectory of their Odoo project to easily and selectively integrate company standards, agents, and tool configurations into their workspace.

## 2. Components

### 2.1. `scripts/install-to-project.sh`
The core script, located in the standards repository.
- **Project Root Detection:** Determines the parent directory of the standards folder.
- **Interactive Menu:** Uses Bash `select` or `read` to present options:
    - **A) Initialize `CLAUDE.md`**: Creates or appends `@import` for the standards.
    - **B) Setup Agents/Commands**: Symlinks `.claude/agents` and `.claude/commands` to the project root.
    - **C) Configure Settings**: Merges marketplace plugins and permissions into `.claude/settings.json`.
    - **D) Setup Pre-commit**: Links or copies `.pre-commit-config.yaml`.

### 2.2. Interactivity & Safety
- **Idempotency:** The script can be run multiple times without causing duplication.
- **Confirmations:** Destructive actions (overwriting files) require explicit user confirmation.
- **Path Awareness:** Automatically handles relative paths based on where `claude-standards` is cloned.

## 3. Implementation Steps

1. **Create `claude-standards/scripts/install-to-project.sh`**.
2. **Implement Logic for `CLAUDE.md`**: Check for existing file, handle `@import` injection.
3. **Implement Logic for Symlinking**: Create `.claude/{agents,commands}` in project root if missing, link files from standards repo.
4. **Implement Logic for `settings.json`**: Use `jq` (if available) or simple string replacement to inject marketplace and plugin configurations.
5. **Add User Feedback**: Clear success/failure messages for each step.

## 4. Verification Plan
- **Mock Integration:** Create a dummy project structure, clone standards into it, and run the script.
- **File Integrity:** Verify `CLAUDE.md` imports work and symlinks are valid.
- **Settings Check:** Ensure `settings.json` remains valid JSON after injection.
