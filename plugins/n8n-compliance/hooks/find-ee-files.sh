#!/bin/bash
# Hook script to find all files and folders containing ".ee." in their names
# Usage: ./find-ee-files.sh [search_directory]
#
# This script identifies enterprise-edition (.ee.) files and folders
# which are typically gated behind license checks in n8n

SEARCH_DIR="${1:-.}"

# Find all files and directories containing ".ee." in their path
find "$SEARCH_DIR" -name "*.ee.*" -o -name "*.ee" -o -name ".ee.*" 2>/dev/null | sort

# Exit with status based on whether any .ee. files were found
if find "$SEARCH_DIR" \( -name "*.ee.*" -o -name "*.ee" -o -name ".ee.*" \) 2>/dev/null | grep -q .; then
    exit 0
else
    exit 1
fi
