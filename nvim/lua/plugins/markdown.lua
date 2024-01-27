return {
  "jakewvincent/mkdnflow.nvim",
  config = function()
    require("mkdnflow").setup({
      mappings = {
        MkdnEnter = {{'i', 'n', 'v'}, '<CR>'},
        MkdnNewListItem = {'i', '<CR>'},
      }
    })
  end,
}
