#!/usr/bin/env bash
# Opens all dirty git files in nvim as buffers
#
# Usage: dirty [--depth N]
#   --depth N  Also search up to N directory levels below the current
#              directory for git repos (default 0: current repo only).

set -euo pipefail

depth=0

while [ $# -gt 0 ]; do
  case "$1" in
    -d | --depth)
      depth="${2:?--depth requires a number}"
      shift 2
      ;;
    --depth=*)
      depth="${1#--depth=}"
      shift
      ;;
    -h | --help)
      sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if ! [[ "$depth" =~ ^[0-9]+$ ]]; then
  echo "--depth must be a non-negative integer" >&2
  exit 1
fi

# Collect repo roots: the repo containing the cwd (if any), plus any repos
# found within $depth levels below it.
repos=()
if top=$(git rev-parse --show-toplevel 2>/dev/null); then
  repos+=("$top")
fi

if [ "$depth" -gt 0 ]; then
  while IFS= read -r gitpath; do
    repos+=("$(cd "$(dirname "$gitpath")" && pwd)")
  done < <(find . -mindepth 2 -maxdepth $((depth + 1)) -name .git -prune)
fi

if [ ${#repos[@]} -eq 0 ]; then
  echo "No git repositories found" >&2
  exit 1
fi

dirty_files=()
while IFS= read -r repo; do
  # Per repo:
  # - git diff --name-only: unstaged changes
  # - git diff --cached --name-only: staged changes
  # - git ls-files --others --exclude-standard: untracked files
  # Paths are repo-root relative, so prefix with the repo root.
  while IFS= read -r f; do
    dirty_files+=("$repo/$f")
  done < <(
    {
      git -C "$repo" diff --name-only
      git -C "$repo" diff --cached --name-only
      git -C "$repo" ls-files --others --exclude-standard
    } | sort -u
  )
done < <(printf '%s\n' "${repos[@]}" | sort -u)

if [ ${#dirty_files[@]} -eq 0 ]; then
  echo "No dirty files found in git"
  exit 0
fi

# Pass to nvim
nvim "${dirty_files[@]}"
