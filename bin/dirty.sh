#!/usr/bin/env bash
# Opens all dirty git files in nvim as buffers

set -euo pipefail

# Get all dirty files using native git commands:
# - git diff --name-only: unstaged changes
# - git diff --cached --name-only: staged changes
# - git ls-files --others --exclude-standard: untracked files
mapfile -t dirty_files < <(
  git diff --name-only
  git diff --cached --name-only
  git ls-files --others --exclude-standard
)

if [ ${#dirty_files[@]} -eq 0 ]; then
  echo "No dirty files found in git"
  exit 0
fi

# Pass to nvim
nvim "${dirty_files[@]}"
