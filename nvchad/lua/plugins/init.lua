return {
  {
     "stevearc/conform.nvim",
     -- event = 'BufWritePre', -- uncomment for format on save
     opts = require "configs.conform",
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
     "neovim/nvim-lspconfig",
     config = function()
       require "configs.lspconfig"
     end,
  },
  {
     'nvim-telescope/telescope.nvim', version = '*',
     opts = function()
       return require("configs.telescope")
     end,
     dependencies = {
       'nvim-lua/plenary.nvim',
       -- optional but recommended
       { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
     },
  },
  {
     "christoomey/vim-tmux-navigator",
     cmd = {
       "TmuxNavigateLeft",
       "TmuxNavigateDown",
       "TmuxNavigateUp",
       "TmuxNavigateRight",
       "TmuxNavigatePrevious",
       "TmuxNavigatorProcessList",
     },
  },
  {
     "lukas-reineke/indent-blankline.nvim",
     main = "ibl",
     opts = function(_, opts)
       -- Other blankline configuration here
       return require("indent-rainbowline").make_opts(opts,{
         color_transparency = 0.15,
       })
     end,
     dependencies = {
       "TheGLander/indent-rainbowline.nvim",
     },
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    'johnfrankmorgan/whitespace.nvim',
    event = "VeryLazy",
    config = function()
      require('whitespace-nvim').setup({})
    end
  },
  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
