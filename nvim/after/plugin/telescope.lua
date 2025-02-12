local lga_actions = require("telescope-live-grep-args.actions")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
    },
  },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension("live_grep_args"))

vim.keymap.set(
  "n",
  "<leader>?",
  require("telescope.builtin").oldfiles,
  { desc = "[?] Find recently opened files" }
)
vim.keymap.set(
  "n",
  "<leader>,",
  "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
  { desc = "Recent buffers" }
)
vim.keymap.set("n", "<leader>ff", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set(
  "n",
  "<leader><space>",
  "<cmd>Telescope find_files<cr>",
  { desc = "[S]earch [F]iles" }
)
vim.keymap.set(
  "n",
  "<leader>sh",
  require("telescope.builtin").help_tags,
  { desc = "[S]earch [H]elp" }
)
vim.keymap.set(
  "n",
  "<leader>sw",
  require("telescope.builtin").grep_string,
  { desc = "[S]earch current [W]ord" }
)
vim.keymap.set(
  "n",
  "<leader>/",
  require("telescope.builtin").live_grep,
  { desc = "[S]earch by [G]rep" }
)
vim.keymap.set(
  "n",
  "<leader>sd",
  "<cmd>Telescope diagnostics bufnr=0<cr>",
  { desc = "[S]earch document [D]iagnostics" }
)
vim.keymap.set(
  "n",
  "<leader>sD",
  "<cmd>Telescope diagnostics<cr>",
  { desc = "[S]earch document [D]iagnostics" }
)
vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "[S]earch [T]odos" })
vim.keymap.set(
  "n",
  "<leader>gf",
  require("telescope.builtin").git_files,
  { desc = "Search [G]it [F]iles" }
)
vim.keymap.set("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_bcommits<CR>", { desc = "Commits of a file" })
vim.keymap.set("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
vim.keymap.set("n", "<leader>sR", "<cmd>Telescope resume<cr>", { desc = "Resume" })
vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fg", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "live_grep with args" })
