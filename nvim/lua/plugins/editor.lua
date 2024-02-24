return {
  {
    "echasnovski/mini.pairs",
    version = false,
    event = { "InsertEnter" },
    config = function()
      require("mini.pairs").setup()
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require('lualine').setup({
        sections = {
          lualine_c = {
            {
              'filename',
              path = 1
            }
          }
        }
      })
    end
  }
}
