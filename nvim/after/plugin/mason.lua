require("mason-tool-installer").setup({
  -- TODO: Maybe move these into LSP, DAP, Format and Lint specific files?
  ensure_installed = {
    "clang-format",
    "prettierd",
    "stylua",
    "luacheck",
    "goimports",
    "shellcheck",
    "shfmt",
    "delve",
    "eslint_d",
  },
  auto_update = true,
})
