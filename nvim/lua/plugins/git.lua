return {
  {
    "tpope/vim-fugitive",
    cmd = "Git",
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    init = function()
      local repo = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.stdpath("config")), ":h")
      vim.g.lazygit_use_custom_config_file_path = 1
      vim.g.lazygit_config_file_path = repo .. "/lazygit/config.yml"
    end,
  },
}
