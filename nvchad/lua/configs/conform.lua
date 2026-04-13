local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		-- IMPORTANT: isort first, then black
		python = { "isort", "black" },
		-- css = { "prettier" },
		-- html = { "prettier" },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 1000,
		lsp_format = "fallback",
	},
}

return options
