return {
  defaults = {
    -- live_grep / grep_string (ripgrep)
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--follow", -- follow symlinks
      "--hidden", -- search dotfiles
      "--no-ignore", -- don't respect .gitignore
      "--glob", "!**/.git/*",
      "--glob", "!**/node_modules/*",
      "--glob", "!**/.DS_Store",
      "--glob", "!**/tmp/cache/assets", -- sprockets
    },
  },
  pickers = {
    find_files = {
      -- find_files (fd)
      find_command = {
        "fd",
        "--type", "f",
        "--strip-cwd-prefix",
        "--follow", -- follow symlinks
        "--hidden", -- search dotfiles
        "--no-ignore", -- don't respect .gitignore
        "--exclude", ".git",
        "--exclude", "node_modules",
        "--exclude", ".DS_Store",
        "--exclude", "tmp/cache/assets", -- sprockets
      },
    },
  },
}

