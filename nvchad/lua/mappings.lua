require "nvchad.mappings"

-- add yours here
vim.g.tmux_navigator_no_mappings = 1

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("i", "jj", "<ESC>", { desc = "Insert: return to Normal"})

map("n", "<C-s>", ":w<cr>", { desc = "Normal: save like a casual"})
map("i", "<C-s>", "<esc>:w<cr>i", { desc = "Insert: save like a casual"})

map("n", "qq", ":qa!<cr>", { desc = "Normal: quit aggressively :qa!"})
map("i", "qq", ":qa!<cr>", { desc = "Insert: quit aggressively :qa!"})

map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "mimic vscode ctrl + p"})
map("i", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "mimic vscode ctrl + p"})

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  { desc = "Normal: tmux left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>",  { desc = "Normal: tmux down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>",    { desc = "Normal: tmux up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Normal: tmux right" })

map("i", "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  { desc = "Insert: tmux left" })
map("i", "<C-j>", "<cmd>TmuxNavigateDown<CR>",  { desc = "Insert: tmux down" })
map("i", "<C-k>", "<cmd>TmuxNavigateUp<CR>",    { desc = "Insert: tmux up" })
map("i", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Insert: tmux right" })
