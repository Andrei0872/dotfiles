return {
  "jakewvincent/mkdnflow.nvim",
  ft = { "markdown" },
  config = function()
    require("mkdnflow").setup({
      mappings = {
        MkdnEnter = {{'i', 'n', 'v'}, '<CR>'},
        MkdnNewListItem = {'i', '<CR>'},
      }
    })
  end,
}
