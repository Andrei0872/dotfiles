require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "cpp",
    "go",
    "lua",
    "rust",
    "tsx",
    "typescript",
    "javascript",
    "svelte",
    "vimdoc",
    "markdown",
    "markdown_inline",
    "json",
    "toml",
    "regex",
    "bash",
    "css",
    "just",
    "starlark",
  },
  sync_install = false,
  auto_install = true,

  ignore_install = {},
  modules = {},

  highlight = { enable = true },
  indent = { enable = true, disable = { "python" } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
  endwise = {
    enable = true,
  },
})

require("treesitter-context").setup({
  -- Make context always show for top-most code block
  -- Other alternative is 'cursor', where context only shows if my cursor is in that top-most code block
  mode = "topline",
  max_lines = 3,
})

vim.keymap.set("n", "<leader>ut", function()
  local tsc = require("treesitter-context")
  tsc.toggle()
end, { desc = "Toggle Treesitter Context" })
