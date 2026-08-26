local lint = require("lint")

-- Configure linters by filetype
lint.linters_by_ft = {
  python = { "ruff" },
  ruby = { "rubocop" },
  javascript = { "eslint" },
  typescript = { "eslint" },
  javascriptreact = { "eslint" },
  typescriptreact = { "eslint" },
}

-- Auto-run linters on these events
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

-- Optional: Add command to manually trigger linting
vim.api.nvim_create_user_command("Lint", function()
  lint.try_lint()
end, {})
