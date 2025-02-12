print("core!")

return {
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    version = "^1.0.0",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
  },
  "nvim-treesitter/nvim-treesitter-context",
  {
    "nvim-treesitter/playground",
    event = "VeryLazy",
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
  },
  "mfussenegger/nvim-lint",
}
