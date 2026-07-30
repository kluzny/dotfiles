# dotfiles

Personal shell, neovim, tmux, and prompt configuration, plus a handful of small utility scripts.

## About me

<!-- TODO: fill this out -->

[kyle.luzny.dev](https://kyle.luzny.dev)

## Layout

- `.aliases`, `.aliases.mac`, `.historyrc`, `customrc` — shell rc files. `customrc` is the entry point, sourcing the others plus a machine-local `~/.workrc`.
- `.vimrc` — legacy Vundle-based config for plain `vim` (not used by Neovim).
- `nvchad/` — Neovim config layered on NvChad. See `nvchad/README.md` for theme, keymaps, LSP, and plugin details.
- `bin/` — personal CLI utilities (`dirty`, `ramchop`, `when.sh`/`when.rb`). Symlinked into `~/.local/bin` by `scripts/install_bins.sh`.
- `scripts/` — standalone, manually-run machine-provisioning scripts.
- `starship.toml`, `keybindings.json`, `.tmux.conf` — prompt, VS Code keybindings, and tmux config.

There's no build step or test suite — changes are verified by exercising whichever script or config file changed.

See `AGENTS.md` for more detailed notes on how these pieces fit together.
