#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bin_dir="$repo_dir/bin"
target_dir="$HOME/.local/bin"

mkdir -p "$target_dir"

for src in "$bin_dir"/*; do
  [ -f "$src" ] || continue
  name="$(basename "$src")"
  dest="$target_dir/$name"

  if [ -L "$dest" ]; then
    current_target="$(readlink "$dest")"
    if [ "$current_target" != "$src" ] && [[ "$current_target" != "$bin_dir"/* ]]; then
      echo "warning: skipping $dest (symlink points elsewhere: $current_target)" >&2
      continue
    fi
    rm "$dest"
  elif [ -e "$dest" ]; then
    echo "warning: skipping $dest (not a symlink, exists already)" >&2
    continue
  fi

  ln -s "$src" "$dest"
  echo "linked $dest -> $src"
done
