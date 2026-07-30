# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## What this is

A personal dotfiles repo: shell rc files, a Neovim config (layered on NvChad), tmux config, a starship prompt, and a handful of small utility scripts. There is no build step, no test suite, and no single "app" to run — changes are verified by exercising the specific script or config file that changed.

## Layout & how the pieces fit together

- **Root rc files** (`.aliases`, `.aliases.mac`, `.historyrc`, `customrc`) — `customrc` is the entry point sourced by the shell's rc file; it sources `.aliases`, `.aliases.mac`, `~/.workrc` (machine-local, gitignored, not in this repo), and `.historyrc`, in that order.
- **`.vimrc`** — legacy Vundle-based config for plain `vim`. Not used by Neovim; don't assume changes here affect the `nvchad/` config or vice versa.
- **`nvchad/`** — the actual Neovim config, layered on the NvChad/NvChad plugin distribution. `nvchad/README.md` already documents the theme, keymaps, LSP setup, and plugin list in detail — read that before making changes here rather than re-deriving it. The one mechanism worth knowing up front: `nvchad/lua/utils.lua` reads `nvchad/.formatignore` (a flat list of directories) to decide whether `conform.nvim`, `nvim-lint`, and the Ruby LSP client should activate at all for a given buffer — check that gate before touching formatting/lint/LSP behavior.
- **`bin/`** — personal CLI utilities (`dirty`, `ramchop`, `when.sh`/`when.rb`). `scripts/install_bins.sh` symlinks everything in `bin/` into `~/.local/bin`; nothing else installs them. `.tmux.conf`'s status bar shells out to `~/.local/bin/ramchop` directly, so that symlink has to exist for the tmux status bar to render correctly.
- **`scripts/`** — machine-provisioning scripts, each run manually and independently; none are chained together. `scripts/setup.sh` is mostly commented-out notes/TODOs, not a working installer. Treat the other `install_*.sh` scripts as standalone, possibly stale references rather than a maintained pipeline.
- **`starship.toml`**, **`keybindings.json`**, **`.tmux.conf`** — prompt, VS Code keybindings, and tmux config respectively. Each is a self-contained leaf config; the only cross-file dependency is `.tmux.conf` → `bin/ramchop` noted above.
- **`Makefile`** — `make help` lists targets; `make lint` runs this repo's own syntax checks (shellcheck, `zsh -n`, `ruby -c`, `luac -p`, `jq`, a TOML parse) against the files below. See "Things worth knowing before editing" for what's covered.

## How these files reach the target environment

The intended install mechanism for this repo is **symlinking, not copying**: a file lives here in the repo and is symlinked from its real location (`$HOME`, `~/.config/nvim`, an editor's user-settings dir, etc.) back to this checkout. Editing a file here edits the live config immediately — there's no build/render/copy step to re-run. `nvchad/` is symlinked whole as `~/.config/nvim`; root rc files (`.aliases`, `.aliases.mac`, `.historyrc`, `.vimrc`) and `starship.toml` are each symlinked individually to their expected path.

`bin/` is the one case with an install script (`scripts/install_bins.sh`) rather than a manual `ln -s`, because it's a directory of many independent utilities that all need linking into `~/.local/bin` — the script exists to do that in bulk, not to change the underlying strategy.

When adding a new top-level config file that should take effect on a machine, keep it symlink-friendly: no templating, no generated/build output, no baked-in absolute path back to this repo. It should be safe to `ln -s` as-is from wherever it needs to live.

## Configuring nvchad

- `nvchad/README.md` is the source of truth for the theme, keymaps, formatting/linting, and LSP setup — read it before changing anything under `nvchad/`, and keep it in sync with what the config actually does.
- Any new plugin, new feature, or otherwise substantial change under `nvchad/` (new keymap, new LSP server, new formatter/linter, changes to the `.formatignore` gating mechanism, etc.) must be documented in `nvchad/README.md` as part of the same change — don't leave it to be reverse-engineered later.
- Small, purely mechanical edits (typo fixes, version bumps, reordering) don't need a README update.

## Do / Don't

**Do:**

- Write scripts to target both Linux and Darwin (macOS) — check for platform-specific commands/flags (e.g. `sed`, `readlink`, package managers) and branch or guard accordingly rather than assuming one platform.
- Keep `README.md` up to date when major technologies change, when a substantial config change lands, or when a new script arrives.

**Don't:**

- Ever commit or push automatically — always leave `git add`/`git commit`/`git push` to the user.

## Things worth knowing before editing

- `bin/when.sh` and `bin/when.rb` are two independent implementations of the same timezone table — when changing behavior in one, check whether the other needs the same change.
- `bin/when.rb` depends on the `lipgloss` gem and self-installs it (`gem install lipgloss`) on first run if missing.
- `.ruby-lsp/Gemfile` is auto-generated by the Ruby LSP for editing this repo's own `bin/when.rb`; it's not something to hand-edit.
- `make lint` (see the `Makefile`) is this repo's own syntax check — shellcheck for `bin/`/`scripts/` bash scripts, `zsh -n` for the rc files, plus `ruby -c`, `luac -p`, `jq`, and a TOML parse for the rest. It's separate from the `conform.nvim`/`nvim-lint` config inside `nvchad/`, which lints *other* projects opened in the editor, not this repo's own files.
