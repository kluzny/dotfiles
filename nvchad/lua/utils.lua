local M = {}

-- Flat list of directories, one per line, where format-on-save should be
-- disabled (e.g. repos with their own linter conventions/CI checks instead
-- of editor autoformat). Blank lines and lines starting with '#' are
-- ignored. Missing file = no exclusions.
M.formatignore_path = vim.fn.stdpath("config") .. "/.formatignore"

local function read_noformat_dirs()
	local dirs = {}
	local file = io.open(M.formatignore_path, "r")
	if not file then
		return dirs
	end

	for line in file:lines() do
		local trimmed = line:match("^%s*(.-)%s*$")
		if trimmed ~= "" and not trimmed:match("^#") then
			table.insert(dirs, vim.fn.expand(trimmed))
		end
	end
	file:close()

	return dirs
end

function M.is_noformat_buf(bufnr)
	local path = vim.api.nvim_buf_get_name(bufnr or 0)
	for _, dir in ipairs(read_noformat_dirs()) do
		if path == dir or path:sub(1, #dir + 1) == dir .. "/" then
			return true
		end
	end
	return false
end

return M
