return {
  "neovim/nvim-lspconfig",

  -- Autocompletion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-cmdline",

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },
  "rafamadriz/friendly-snippets",

  -- optional `vim.uv` typings
  { "Bilal2453/luvit-meta", lazy = true },

  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },
}
