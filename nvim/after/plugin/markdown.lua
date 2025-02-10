require("mkdnflow").setup({
  mappings = {
    MkdnEnter = { { "i", "n", "v" }, "<CR>" },
    MkdnNewListItem = { "i", "<CR>" },
  },
})

require("markdowny").setup()
