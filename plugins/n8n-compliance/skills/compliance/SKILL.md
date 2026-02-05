# Compliance Skill

**Usage:** `/compliance <command> <feature-name>`

**Description:** Orchestrates the removal of enterprise gating from n8n features while preserving full functionality.

---

## Commands

### `/compliance examine <feature-name>`

Invokes the **Examination Agent** to:
- Perform deep analysis of the specified feature
- Identify all `.ee.` files for removal
- Generate generalized documentation (`FEATURE_SPEC.md`)

**Output:** Documentation files in `compliance-work/<feature-name>/`

### `/compliance implement <feature-name>`

Invokes the **Implementation Agent** to:
- Read the generated `FEATURE_SPEC.md`
- Remove all `.ee.` files for the feature
- Implement the feature from documentation
- Build and validate

**Prerequisite:** Run `examine` first and verify documentation manually.

### `/compliance full <feature-name>`

Runs the complete workflow:
1. Examine and document
2. **Pause for manual verification**
3. Remove `.ee.` files
4. Implement from documentation
5. Build and validate

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     COMPLIANCE WORKFLOW                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────┐      ┌──────────────────────────────┐    │
│  │ EXAMINATION      │      │ Output:                      │    │
│  │ AGENT            │─────▶│ - FEATURE_SPEC.md            │    │
│  │                  │      │ - FILES_TO_REMOVE.md         │    │
│  │ Analyzes feature │      │ - ANALYSIS_NOTES.md          │    │
│  └──────────────────┘      └──────────────────────────────┘    │
│           │                                                     │
│           ▼                                                     │
│  ┌──────────────────┐                                          │
│  │ MANUAL REVIEW    │  ◀── Human verifies documentation        │
│  │ (Required)       │      contains no copied code             │
│  └──────────────────┘                                          │
│           │                                                     │
│           ▼                                                     │
│  ┌──────────────────┐      ┌──────────────────────────────┐    │
│  │ IMPLEMENTATION   │      │ Actions:                     │    │
│  │ AGENT            │─────▶│ - Removes .ee. files         │    │
│  │                  │      │ - Implements from spec       │    │
│  │ Fresh session    │      │ - Builds & validates         │    │
│  └──────────────────┘      └──────────────────────────────┘    │
│           │                                                     │
│           ▼                                                     │
│  ┌──────────────────┐                                          │
│  │ MERGE REQUEST    │  ◀── Create MR, get team review          │
│  └──────────────────┘                                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Working Directory Structure

When running compliance tasks, files are organized as:

```
compliance-work/
└── <feature-name>/
    ├── FEATURE_SPEC.md      # Generalized documentation
    ├── FILES_TO_REMOVE.md   # List of .ee. files to remove
    ├── ANALYSIS_NOTES.md    # Additional observations
    └── IMPLEMENTATION.md    # Post-implementation notes
```

---

## Critical Rules

### Documentation Must NOT Contain:
- Original function names
- Original variable names
- Original file paths
- Direct code snippets
- Exact API route strings
- Database table/column names verbatim

### Implementation Must NOT Include:
- License checks
- Enterprise feature flags
- "Upgrade to enterprise" prompts
- Any `.ee.` in file names

### Process Requirements:
- Manual review of documentation is **mandatory**
- Implementation agent must run in a **fresh session**
- Build must succeed before marking complete
- Feature must work identically (minus enterprise gates)

---

## Quick Reference

| Phase | Agent | Input | Output |
|-------|-------|-------|--------|
| Examine | Examination | Feature name | FEATURE_SPEC.md |
| Review | Human | Documentation | Approval |
| Implement | Implementation | FEATURE_SPEC.md | Working feature |
| Validate | Human | Running app | MR approval |

---

## Enterprise Features Reference

Check `packages/@n8n/constants/src/index.ts` for the list of enterprise-gated features.
