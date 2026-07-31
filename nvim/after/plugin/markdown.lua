require("mkdnflow").setup({
  mappings = {
    MkdnEnter = { { "i", "n", "v" }, "<CR>" },
    MkdnNewListItem = { "i", "<CR>" },
    MkdnDecreaseHeading = false,
  },
})

require("markdowny").setup()
