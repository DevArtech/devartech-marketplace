# Compliance Skill

**Usage:** `/compliance <command> <feature-name>`

**Description:** Orchestrates the removal of enterprise gating from n8n features while preserving full functionality.

---

## Commands

### `/compliance examine <feature-name>`

Invokes the **Examination Agent** to:
- Use the `/ee-files` hook to discover all `.ee.` files in the codebase
- Perform deep analysis of the specified feature
- Identify which `.ee.` files are related to the feature for removal
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
2. **Automated validation** - Claude analyzes outputs to verify:
   - Documentation is complete and implementation-ready
   - No proprietary code/names are included
   - All `.ee.` files are identified
   - Only pauses for human review if issues are detected
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
│  │ Uses /ee-files   │      │ - ANALYSIS_NOTES.md          │    │
│  │ hook to discover │      │                              │    │
│  └──────────────────┘      └──────────────────────────────┘    │
│           │                                                     │
│           ▼                                                     │
│  ┌──────────────────┐                                          │
│  │ AUTOMATED        │  ◀── Claude validates documentation      │
│  │ VALIDATION       │      meets all requirements              │
│  │                  │                                          │
│  │ Only pauses if   │  ◀── Issues? → Human review              │
│  │ issues detected  │      No issues? → Continue               │
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

## Automated Validation Criteria

During the `full` command, Claude automatically validates that the examination output:

1. **Completeness** - FEATURE_SPEC.md contains all necessary sections for implementation
2. **No Proprietary Content** - Documentation does not contain:
   - Original function/variable names from source
   - Direct code snippets
   - Exact API routes or database schemas
3. **File Coverage** - FILES_TO_REMOVE.md lists all relevant `.ee.` files (discovered via `/ee-files` hook)
4. **Implementation Readiness** - Spec is detailed enough to implement without referencing original code

**If validation passes:** Proceeds automatically to implementation phase.

**If issues detected:** Claude stops and reports specific concerns to the human for review.

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
- Automated validation of documentation is performed by Claude
- Human review only required if Claude detects issues or is uncertain
- Implementation agent must run in a **fresh session**
- Build must succeed before marking complete
- Feature must work identically (minus enterprise gates)

---

## Quick Reference

| Phase | Agent | Input | Output |
|-------|-------|-------|--------|
| Examine | Examination | Feature name | FEATURE_SPEC.md |
| Validate | Claude | Documentation | Auto-approval or issues |
| Review | Human (if needed) | Issues report | Approval |
| Implement | Implementation | FEATURE_SPEC.md | Working feature |
| Final Check | Human | Running app | MR approval |

---

## Hooks

### `/ee-files`

Lists all `.ee.` (enterprise edition) files in the n8n codebase. The examination agent uses this hook as the starting point to discover enterprise-gated code, then filters to identify files relevant to the specific feature being analyzed.

---

## Enterprise Features Reference

Check `packages/@n8n/constants/src/index.ts` for the list of enterprise-gated features.
