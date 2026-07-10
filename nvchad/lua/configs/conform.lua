local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		ruby = { "rubocop" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
	},

	format_on_save = function(bufnr)
		if require("utils").is_noformat_buf(bufnr) then
			return nil
		end
		-- These options will be passed to conform.format()
		return {
			timeout_ms = 1000,
			lsp_format = "fallback",
		}
	end,
}

return options
