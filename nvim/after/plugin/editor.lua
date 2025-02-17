require("mini.pairs").setup()
require("Comment").setup()
require("todo-comments").setup({
  signs = false,
})

require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

