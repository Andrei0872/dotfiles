require("mkdnflow").setup({
  links = {
    style = "wiki",
  },
  mappings = {
    MkdnEnter = { { "i", "n", "v" }, "<CR>" },
    MkdnNewListItem = { "i", "<CR>" },
    MkdnDecreaseHeading = false,
  },
})

require("markdowny").setup()

-- Names a pasted image after the current file: `<file>.png` for the first one,
-- then `<file>-2.png`, `<file>-3.png`, ... so existing images are never overwritten
local function next_image_name()
  local dir = vim.fn.expand("%:p:h") .. "/_assets/"
  local base = vim.fn.expand("%:t:r")
  local name, n = base, 1
  while vim.fn.filereadable(dir .. name .. ".png") == 1 do
    n = n + 1
    name = base .. "-" .. n
  end
  return name
end

require("img-clip").setup({
  filetypes = {
    markdown = {
      dir_path = "_assets",
      relative_to_current_file = true,
      file_name = next_image_name,
      prompt_for_file_name = false,
    },
  },
})
