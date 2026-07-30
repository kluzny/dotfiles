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
- `Makefile` — `make help` for targets, `make lint` to syntax-check the repo (see Linting below).

There's no build step or test suite — changes are verified by exercising whichever script or config file changed.

## Installing

These files are meant to be **symlinked** into place, not copied — `ln -s` a given file from its real target (`$HOME`, `~/.config/nvim`, an editor's user-settings dir, etc.) to its path in this checkout. Edits here take effect immediately since the target is just a link back to the repo. `nvchad/` is linked whole as `~/.config/nvim`; the root rc files and `starship.toml` are linked individually. `bin/` is the exception — `scripts/install_bins.sh` symlinks the whole directory into `~/.local/bin` in one shot rather than by hand.

## Linting

`make lint` runs the syntax checks this repo has: shellcheck for `bin/`/`scripts/` shell scripts, `zsh -n` for the rc files, and `ruby -c` / `luac -p` / `jq` / a TOML parse for the rest. Run `make help` to see all targets.

See `AGENTS.md` for more detailed notes on how these pieces fit together.
