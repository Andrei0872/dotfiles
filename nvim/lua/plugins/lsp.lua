return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "b0o/SchemaStore.nvim",
        lazy = true,
        version = false,
      },
    },
    keys = {
      { "<leader>sr", "<cmd>:lua vim.lsp.buf.rename()<cr>", desc = "Rename symbol" },
    },
    config = function()
      local util = require("lspconfig.util")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local handlers = {
        ["textDocument/publishDiagnostics"] = function(a, b, c, d)
          local pp = require 'pl.pretty'
          pp.dump(a or {})
          pp.dump(b or {})
          pp.dump(c or {})
          pp.dump(d or {})
        end,
      },

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "tsserver",
          "html",
          "cssls",
          "cssmodules_ls",
          "jsonls",
        }
      })

      require'lspconfig'.lua_ls.setup{
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
              Lua = {
                runtime = {
                  version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  --									library = {
                  --										vim.env.VIMRUNTIME
                  --										-- "${3rd}/luv/library"
                  --										-- "${3rd}/busted/library",
                  --									}
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  library = vim.api.nvim_get_runtime_file("", true)
                }
              }
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end,
        capabilities = capabilities,
        handlers = handlers
      }

      require'lspconfig'.tsserver.setup{
        root_dir = util.root_pattern(".git"),
        capabilities = capabilities,
        handlers = handlers,
      }

      require'lspconfig'.html.setup{
        capabilities = capabilities,
        handlers = handlers,
      }

      require'lspconfig'.cssls.setup{
        capabilities = capabilities,
        handlers = handlers,
      }

      require'lspconfig'.cssmodules_ls.setup{
        capabilities = capabilities,
        handlers = handlers,
      }

      require'lspconfig'.jsonls.setup{
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = {
          json = {
            format = {
              enable = true,
            },
            validate = { enable = true },
          },
        },
        capabilities = capabilities,
        handlers = handlers,
      }
    end
  }
}
