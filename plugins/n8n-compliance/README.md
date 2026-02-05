# n8n Compliance Plugin

A Claude Code plugin for removing enterprise gating from n8n features and rebuilding them as fully-functional, license-free implementations using a clean-room approach.

## Overview

This plugin provides a structured workflow to:

1. **Examine** enterprise-gated features in the n8n codebase
2. **Document** their functionality without copying proprietary code
3. **Remove** enterprise-edition (`.ee.`) files
4. **Reimplement** the features from generalized specifications

The result is functionality that works out-of-box for all users without license checks or enterprise gates.

## Installation

1. Install the marketplace then install the plugin:
   ```bash
    /plugin marketplace add https://github.com/DevArtech/devartech-marketplace
    /plugin install n8n-compliance@devartech-marketplace
   ```

2. Ensure Claude Code recognizes the plugin by verifying the `.claude-plugin/plugin.json` exists.

3. The plugin will be automatically loaded when working in directories where it's relevant.

## Components

### Agents

| Agent | Purpose |
|-------|---------|
| **enterprise-feature-examiner** | Analyzes enterprise features and generates clean-room documentation |
| **n8n-feature-implementer** | Implements features from specifications without enterprise gating |

### Skills

| Command | Description |
|---------|-------------|
| `/compliance examine <feature>` | Analyze a feature and generate documentation |
| `/compliance implement <feature>` | Implement a feature from its specification |
| `/compliance full <feature>` | Run the complete examination and implementation workflow |

### Hooks

| Hook | Description |
|------|-------------|
| `find-ee-files` | Locates all `.ee.` files and folders in a directory |

## Workflow

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
│  │ FINAL REVIEW     │  ◀── Verify implementation works         │
│  └──────────────────┘                                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Usage Examples

### Examine a Feature

```
> Examine the SAML authentication feature

Claude will use the enterprise-feature-examiner agent to:
- Locate all .ee. files related to SAML
- Analyze the feature's architecture
- Generate FEATURE_SPEC.md with generalized documentation
- Create FILES_TO_REMOVE.md listing enterprise files
```

### Implement a Feature

```
> Implement the variables feature from the spec

Claude will use the n8n-feature-implementer agent to:
- Read FEATURE_SPEC.md
- Remove listed .ee. files
- Build the feature from documentation
- Validate with pnpm build
```

### Find Enterprise Files

Run the hook directly:
```bash
./hooks/find-ee-files.sh /path/to/n8n
```

## Output Structure

Documentation is generated in `compliance-work/<feature-name>/`:

```
compliance-work/
└── <feature-name>/
    ├── FEATURE_SPEC.md      # Generalized documentation
    ├── FILES_TO_REMOVE.md   # List of .ee. files to remove
    ├── ANALYSIS_NOTES.md    # Additional observations
    └── IMPLEMENTATION.md    # Post-implementation notes
```

## Clean-Room Requirements

### Documentation Must NOT Contain:
- Original function, method, or class names
- Original variable or constant names
- Direct code snippets
- Exact API route strings
- Database table/column names verbatim

### Implementation Must NOT Include:
- License checks of any kind
- Enterprise feature flags
- "Upgrade to enterprise" prompts
- Any `.ee.` in file names
- Conditional logic based on license tier

## MCP Servers

The plugin includes these MCP servers for browser-based testing:

- **chrome-devtools** - For debugging and UI inspection
- **playwright** - For automated browser testing

## Requirements

- Claude Code CLI
- Access to an n8n codebase
- Node.js and pnpm (for building n8n)

## License

This plugin is a tool for compliance work. Users are responsible for ensuring their use complies with applicable licenses and laws.
