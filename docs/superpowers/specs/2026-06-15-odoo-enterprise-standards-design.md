# Design Spec: Odoo Enterprise Standards (Multi-Company/Website)

**Date:** 2026-06-15  
**Topic:** Odoo Enterprise Alignment — Strict Guardrails & Audit  
**Status:** Draft

## 1. Purpose
Align the `claude-standards` repository with Odoo Enterprise requirements, specifically focusing on **Multi-Company** and **Multi-Website** isolation and security. The goal is to enforce "Isolation by Default" through automated auditing and strict coding standards.

## 2. Components

### 2.1. `CLAUDE.md` Enhancement
Update the company-wide engineering standard to include a dedicated **Section 8: Enterprise Multi-Company/Website**.
- **Mandatory Fields:** `company_id` with default `env.company`.
- **Relational Consistency:** Use of `_check_company_auto = True` and `check_company=True`.
- **Context Management:** Guidelines for `with_company()`, `env.companies`, and avoiding `sudo()` without company filtering.

### 2.2. `odoo-version-guardrails.md` Extension
Add a new section for **Enterprise-Specific Guardrails**:
- **Website:** `website_id` filtering and `website_published` logic.
- **Record Rules:** Template for Odoo 17+ rules using `('company_id', 'in', company_ids)`.

### 2.3. New Agent: `odoo-enterprise-auditor`
A specialized subagent (`.claude/agents/odoo-enterprise-auditor.md`) that:
- Scans Python files for missing `company_id` fields in new models.
- Checks for missing `check_company=True` on relational fields.
- Flags `sudo()` usages that don't explicitly filter by company or explain why.
- Verifies that record rules use the `company_ids` list.

### 2.4. New Skill: `verify-multi-company`
A reusable procedural skill to automate the validation of multi-company logic.
- **Procedure:** 
    1. Identify all new models.
    2. Check for `company_id` presence.
    3. Grep for `record rules` in security XMLs.
    4. Run `odoo-enterprise-auditor` on the diff.

## 3. Implementation Steps

1.  **Update `claude-standards/CLAUDE.md`**: Add Multi-Company standards.
2.  **Update `claude-standards/docs/odoo-version-guardrails.md`**: Add Enterprise/Multi-Website rows.
3.  **Create `.claude/agents/odoo-enterprise-auditor.md`**: Define the new agent.
4.  **Create `skills/odoo/verify-multi-company.md`**: Define the verification procedure.
5.  **Sync to Client**: Simulate the sync of these standards to `acme-erp-odoo19` (if requested).

## 4. Verification Plan
- **Manual Check:** Verify that the new agent can identify a deliberate isolation leak (e.g., a Many2one field without `check_company`).
- **Standard Review:** Ensure `CLAUDE.md` instructions are clear and concise.
