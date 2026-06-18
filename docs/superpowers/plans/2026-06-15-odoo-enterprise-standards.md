# Odoo Enterprise Standards Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Align the company's Odoo engineering standards with Enterprise Multi-Company and Multi-Website requirements by introducing strict guardrails and an automated auditor.

**Architecture:** Enhances existing documentation (`CLAUDE.md`, `guardrails.md`) and introduces a new specialized agent (`odoo-enterprise-auditor`) and a verification skill.

**Tech Stack:** Odoo 17+, Python, XML, Gemini CLI Agents/Skills.

---

### Task 1: Update CLAUDE.md with Multi-Company Standards

**Files:**
- Modify: `claude-standards/CLAUDE.md`

- [ ] **Step 1: Add Section 8 (Enterprise Multi-Company/Website)**
Add a new section defining mandatory `company_id` patterns, `_check_company_auto`, and `with_company()` usage.
- [ ] **Step 2: Verify wording**
Ensure instructions are explicit about "Isolation by Default".
- [ ] **Step 3: Commit**
`git add claude-standards/CLAUDE.md && git commit -m "docs: add multi-company standards to CLAUDE.md"`

---

### Task 2: Update Guardrails Matrix

**Files:**
- Modify: `claude-standards/docs/odoo-version-guardrails.md`

- [ ] **Step 1: Add Enterprise/Multi-Website rows**
Add information about `website_id`, `website_published`, and the Odoo 17+ record rule template using `company_ids`.
- [ ] **Step 2: Commit**
`git add claude-standards/docs/odoo-version-guardrails.md && git commit -m "docs: add enterprise guardrails to version matrix"`

---

### Task 3: Create Odoo Enterprise Auditor Agent

**Files:**
- Create: `claude-standards/.claude/agents/odoo-enterprise-auditor.md`

- [ ] **Step 1: Define the agent**
Include instructions to flag missing `company_id`, missing `check_company=True`, and suspicious `sudo()` usage.
- [ ] **Step 2: Commit**
`git add claude-standards/.claude/agents/odoo-enterprise-auditor.md && git commit -m "feat: add odoo-enterprise-auditor agent"`

---

### Task 4: Create Multi-Company Verification Skill

**Files:**
- Create: `claude-standards/docs/superpowers/skills/verify-multi-company.md`

- [ ] **Step 1: Define the skill**
Document the procedure: model scanning, record rule grep, and running the enterprise auditor.
- [ ] **Step 2: Commit**
`git add claude-standards/docs/superpowers/skills/verify-multi-company.md && git commit -m "feat: add verify-multi-company skill"`
