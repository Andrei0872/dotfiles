local conform = require("conform")

local prettier = { "prettierd", "prettier" }

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    rust = { "rustfmt" },
    go = { "goimports" },
    toml = { "taplo" },
    json = prettier,
    markdown = prettier,

    html = prettier,
    css = prettier,

    javascript = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    javascriptreact = prettier,
    svelte = prettier,
  },
})

-- TODO: create command that will enable/disable automatic formatting on save.

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({
    bufnr = vim.api.nvim_get_current_buf(),
    stop_after_first = true,
  })
end)
