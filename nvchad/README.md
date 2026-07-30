**This repo is supposed to be used as config by NvChad users!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

# Customizations

This config layers a personal setup on top of stock NvChad. The major changes:

## Theme

- `tomorrow_night` colorscheme, set in `lua/chadrc.lua`.

## Keymaps

Defined in `lua/mappings.lua`, on top of NvChad's defaults:

- `;` enters command mode.
- `jj` exits insert mode.
- `<C-s>` saves, from normal or insert mode.
- `qq` force-quits all buffers.
- `<C-p>` mimics VS Code's fuzzy file finder.
- `<C-h/j/k/l>` pass pane navigation through to tmux via `vim-tmux-navigator`.

## Formatting & Linting

- `conform.nvim` (`lua/configs/conform.lua`) formats on save, with per-filetype formatters: stylua, ruff, rubocop, prettier, etc.
- `nvim-lint` (`lua/configs/lint.lua`) runs filetype-specific linters — ruff, rubocop, eslint — on buffer enter, save, and leaving insert mode.
- Both respect the per-project opt-out described below.

## LSP

Configured in `lua/configs/lspconfig.lua` and `lsp/ruby_lsp.lua`.

- Enabled servers: `html`, `cssls`, `ruby_lsp`, `pyright`.
- The Ruby LSP config is heavily customized:
  - Runs via an asdf shim rather than Mason.
  - Enables an expanded set of ruby-lsp features: inlay hints, code lens, semantic highlighting, and more.
  - Formats Ruby buffers on save through the LSP client itself, rather than through conform.
  - Respects the per-project opt-out described below when deciding whether to start at all.

## Per-project opt-out

- `lua/utils.lua` reads a flat list of directories from `.formatignore` (one per line, at the config root).
- Directories on that list get no autoformatting and no Ruby LSP client — intended for repos that manage their own linting/CI instead of relying on editor tooling.
- Both `conform.nvim` and the Ruby LSP config check this list before acting.

## Search

Telescope (`lua/configs/telescope.lua`) tunes both `find_files` and `live_grep` to:

- Search hidden files and ignore `.gitignore`.
- Still exclude noisy directories: `node_modules`, `.venv`, `.git`, and Rails/Sprockets cache and asset paths.

## Folding

- `lua/configs/folding.lua` uses indent-based folding with all folds open by default.

## Extra plugins

Added in `lua/plugins/init.lua`, beyond the NvChad defaults:

- `vim-tmux-navigator` — pane navigation between vim and tmux.
- `indent-blankline.nvim` + `indent-rainbowline.nvim` — rainbow indent guides.
- `todo-comments.nvim` — highlight TODO-style comments.
- `whitespace.nvim` — trailing-whitespace highlighting.
- `yank-path.nvim` — a personal plugin with keymaps to yank the current file's path, name, or directory.

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
