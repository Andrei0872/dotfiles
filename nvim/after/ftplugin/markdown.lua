vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

vim.opt_local.wrap = true          -- soft-wrap long lines visually
vim.opt_local.linebreak = true     -- break at word boundaries, not mid-word
vim.opt_local.breakindent = true   -- wrapped lines keep the indent of the original line
vim.opt_local.showbreak = "↳ "     -- mark wrapped continuation lines
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })

vim.keymap.set("i", "<C-y>", "**<Left>", { buffer = true })
vim.keymap.set("i", "<C-b>", "****<Left><Left>", { buffer = true })
vim.keymap.set("i", "<C-e>", "``<Left>", { buffer = true })

vim.keymap.set("n", "<leader>ip", "<cmd>PasteImage<CR>", { buffer = true })
