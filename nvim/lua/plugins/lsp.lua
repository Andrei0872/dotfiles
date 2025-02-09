return {
  -- "neovim/nvim-lspconfig",

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",

      {
        "L3MON4D3/LuaSnip",

        version = "v2.*",
        build = "make install_jsregexp",

        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
  },
  -- "hrsh7th/cmp-buffer",
  -- "hrsh7th/cmp-path",
  -- "saadparwaiz1/cmp_luasnip",
  -- "hrsh7th/cmp-nvim-lsp",
  -- "hrsh7th/cmp-nvim-lua",

  -- Snippets
  -- {
  --   "L3MON4D3/LuaSnip",
  --   version = "v2.*",
  --   build = "make install_jsregexp",
  -- },
  -- "rafamadriz/friendly-snippets",

  -- optional `vim.uv` typings
  { "Bilal2453/luvit-meta", lazy = true },
}
