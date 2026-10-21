local function lazygit_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local job = vim.b[buf].terminal_job_id
    if vim.bo[buf].filetype == "lazygit" and job and vim.fn.jobwait({ job }, 0)[1] == -1 then
      return buf
    end
  end
end

-- Close lazygit's floating window but keep the process running, so reopening it
-- restores the exact state (selected file, focused panel, ...).
local function lazygit_hide()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "lazygit" then
      vim.api.nvim_win_close(win, true)
    end
  end
end

-- Show the hidden lazygit if there is one, otherwise start a new one.
local function lazygit_open()
  local buf = lazygit_buf()
  if not buf then
    return require("lazygit").lazygit()
  end

  -- Same geometry/look as lazygit.nvim's own floating window.
  local scale = vim.g.lazygit_floating_window_scaling_factor
  scale = type(scale) == "number" and scale or 0.9
  local height = math.ceil(vim.o.lines * scale) - 1
  local width = math.ceil(vim.o.columns * scale)
  local win = vim.api.nvim_open_win(buf, true, {
    style = "minimal",
    relative = "editor",
    row = math.ceil(vim.o.lines - height) / 2,
    col = math.ceil(vim.o.columns - width) / 2,
    width = width,
    height = height,
    border = vim.g.lazygit_floating_window_border_chars,
  })
  vim.wo[win].winhl = "FloatBorder:LazyGitBorder,NormalFloat:LazyGitFloat"
  vim.cmd("startinsert")
end

return {
  {
    "tpope/vim-fugitive",
    cmd = "Git",
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    init = function()
      local repo = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.stdpath("config")), ":h")
      vim.g.lazygit_use_custom_config_file_path = 1
      vim.g.lazygit_config_file_path = repo .. "/lazygit/config.yml"

      -- Called by lazygit's `os.edit*` commands (see lazygit/config.yml).
      vim.api.nvim_create_user_command("LazyGitHide", lazygit_hide, {})
    end,
    config = function()
      -- Replace the plugin's `:LazyGit` so it reopens a hidden lazygit instead of
      -- starting a fresh one.
      vim.api.nvim_create_user_command("LazyGit", lazygit_open, { force = true })
    end,
  },
}
