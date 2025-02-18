require("mini.pairs").setup()
require("Comment").setup()
require("todo-comments").setup({
  signs = false,
})

-- TODO: if preview open, use <C-{d,u}> for scrolling in preview mode.
-- https://github.com/stevearc/oil.nvim/issues/41
require("oil").setup({
  -- ["<>"] = false,
  -- ["\""] = { "actions.select", opts = { horizontal = true } },
  --
  -- ["<C-l>"] = false,
  -- ["<leader>r"] = "actions.refresh",
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
