return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        graphql = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        html = { "htmlbeautifier" },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
        cpp = { "clang_format" },
        c = { "clang_format" }
      },
    }) 

    --	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    --		pattern = "*",
    --		callback = function(args)
    --			require("conform").format({ bufnr = args.buf })
    --		end,
    --	})

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({
        --				lsp_fallback = true,
        --				async = false,
        --				timeout_ms = 1000,
        bufnr = vim.api.nvim_get_current_buf(),
      })
    end)
  end,
}
