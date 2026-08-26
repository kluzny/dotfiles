local o = vim.o

o.foldcolumn = "1"
o.foldmethod = "indent"
o.foldenable = false
o.foldlevel = 99 -- start with all folds open

-- Testing
-- 1 comment
  -- 2 comment
  -- 2 comment
    -- 3 comment
    -- 3 comment
    -- 3 comment
      -- 4 comment
      -- 4 comment
      -- 4 comment
      -- 4 comment
