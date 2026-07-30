SHELL := /bin/bash

.DEFAULT_GOAL := help

### Utilities
.PHONY: help

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Utilities:"
	@echo "  help               Show this help"
	@echo ""
	@echo "Lints:"
	@echo "  lint               Run all lint/syntax checks"
	@echo "  lint-shellcheck    shellcheck bash scripts in bin/ and scripts/"
	@echo "  lint-zsh           zsh -n syntax check for rc files"
	@echo "  lint-ruby          ruby -c syntax check for bin/when.rb"
	@echo "  lint-lua           luac -p syntax check for nvchad lua files"
	@echo "  lint-json          jq syntax check for keybindings.json"
	@echo "  lint-toml          python3 tomllib syntax check for starship.toml"

### Lints
.PHONY: lint lint-shellcheck lint-zsh lint-ruby lint-lua lint-json lint-toml

lint: lint-shellcheck lint-zsh lint-ruby lint-lua lint-json lint-toml

lint-shellcheck:
	@if command -v shellcheck >/dev/null 2>&1; then \
		echo "==> shellcheck bin/*.sh scripts/*.sh"; \
		shellcheck $(wildcard bin/*.sh) $(wildcard scripts/*.sh); \
	else \
		echo "skip: shellcheck not installed"; \
	fi

lint-zsh:
	@if command -v zsh >/dev/null 2>&1; then \
		for f in customrc .aliases .aliases.mac .historyrc; do \
			echo "==> zsh -n $$f"; \
			zsh -n "$$f" || exit 1; \
		done; \
	else \
		echo "skip: zsh not installed"; \
	fi

lint-ruby:
	@if command -v ruby >/dev/null 2>&1; then \
		echo "==> ruby -c bin/when.rb"; \
		ruby -c bin/when.rb; \
	else \
		echo "skip: ruby not installed"; \
	fi

lint-lua:
	@if command -v luac >/dev/null 2>&1; then \
		echo "==> luac -p (nvchad lua files)"; \
		luac -p $$(find nvchad -name '*.lua'); \
	else \
		echo "skip: luac not installed"; \
	fi

lint-json:
	@if command -v jq >/dev/null 2>&1; then \
		echo "==> jq empty keybindings.json"; \
		jq empty keybindings.json; \
	else \
		echo "skip: jq not installed"; \
	fi

lint-toml:
	@if command -v python3 >/dev/null 2>&1 && python3 -c "import tomllib" >/dev/null 2>&1; then \
		echo "==> python3 tomllib starship.toml"; \
		python3 -c "import tomllib; tomllib.load(open('starship.toml', 'rb'))"; \
	else \
		echo "skip: python3 tomllib unavailable (requires Python 3.11+)"; \
	fi
