#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# source path (relative to repo) -> target path (absolute, under $HOME)
configs=(
  "starship.toml:$HOME/.config/starship.toml"
  ".config/nvim:$HOME/.config/nvim"
  ".config/herdr/config.toml:$HOME/.config/herdr/config.toml"
)

for entry in "${configs[@]}"; do
  name="${entry%%:*}"
  dest="${entry#*:}"
  src="$repo_dir/$name"

  if [ ! -e "$src" ]; then
    echo "warning: skipping $dest (source $src does not exist)" >&2
    continue
  fi

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    current_target="$(readlink "$dest")"
    if [ "$current_target" != "$src" ] && [[ "$current_target" != "$repo_dir"/* ]]; then
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
