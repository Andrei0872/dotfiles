return {
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown" },
  },
  {
    ft = { "markdown" },
    "antonk52/markdowny.nvim",
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
