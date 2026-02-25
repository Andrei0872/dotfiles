local lsp = vim.lsp
local tele = require("telescope.builtin")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "clangd",
    "gopls",
    "jsonls",
    "lua_ls",
    "marksman",
    "rust_analyzer",
    "svelte",
    "taplo",
    "ts_ls",
    "yamlls",
    "html",
    "bashls",
  },
  handlers = {
    html = function()
      require("lspconfig").html.setup({
        filetypes = { "html", "templ" },
      })
    end,
  },
})

-- function to reduce boilerplate for setting keymaps
local map = function(mode, keys, func, desc)
  if desc then
    desc = "LSP: " .. desc
  end
  vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
end

-- Goto keymaps
map("n", "gd", tele.lsp_definitions, "[G]oto [D]efinition")
map("n", "go", tele.lsp_type_definitions, "[G]oto Type Definition")
map("n", "gD", lsp.buf.declaration, "[G]oto [D]eclaration")
map("n", "gI", tele.lsp_implementations, "[G]oto [I]mplementation")
map("n", "gr", tele.lsp_references, "[G]oto [R]eferences")
map("n", "gs", lsp.buf.signature_help, "[G]oto [S]ignature")
map("n", "K", lsp.buf.hover, "Hover")
map("n", "gK", lsp.buf.signature_help, "Signature Help")
map("i", "<c-k>", lsp.buf.signature_help, "Signature Help")

-- Useful lsp actions
map("n", "<leader>rn", lsp.buf.rename, "[R]e[N]ame")
map({ "n", "v" }, "<leader>ca", lsp.buf.code_action, "[C]ode [A]ction")
map("n", "<leader>cA", function()
  vim.lsp.buf.code_action({
    context = {
      only = {
        "source",
      },
      diagnostics = {},
    },
  })
end, "Source action")

-- File navigation
map("n", "<leader>o", "<cmd>AerialToggle!<cr>", "[O]utline")

-- Diagnostics
map("n", "gl", vim.diagnostic.open_float, "Open diagnostic float")
map("n", "]d", vim.diagnostic.goto_next, "Jump to the next diagnostic")
map("n", "[d", vim.diagnostic.goto_prev, "Jump to the previous diagnostic")

-- search symbols
map("n", "<leader>ss", require("telescope.builtin").lsp_document_symbols, "[S]ymbols: [D]ocument")
map(
  "n",
  "<leader>sS",
  require("telescope.builtin").lsp_dynamic_workspace_symbols,
  "[S]ymbols: [W]orkspace"
)

-- Lesser used LSP functionality
map("n", "<leader>wa", lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
map("n", "<leader>wr", lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
map("n", "<leader>wl", function()
  print(vim.inspect(lsp.buf.list_workspace_folders()))
end, "[W]orkspace [L]ist Folders")

-- Load FriendlySnippets
require("luasnip.loaders.from_vscode").lazy_load()

-- autocompletion
local cmp = require("cmp")

local function select_next()
  if cmp.visible() then
    cmp.select_next_item({ behavior = "select" })
  else
    cmp.complete()
  end
end
local function select_prev()
  if cmp.visible() then
    cmp.select_prev_item({ behavior = "select" })
  else
    cmp.complete()
  end
end

cmp.setup({
  completion = {
    completeopt = "menu,menuone,preview,noselect",
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip", keyword_length = 2 },
    { name = "buffer", keyword_length = 3 },
    { name = "path" },
  }),
  mapping = cmp.mapping.preset.insert({
    -- ["<C-n>"] = cmp.mapping(select_next),
    -- ["<C-j>"] = cmp.mapping(select_next),
    -- ["<C-p>"] = cmp.mapping(select_prev),
    -- ["<C-k>"] = cmp.mapping(select_prev),
    -- ["<C-y>"] = cmp.mapping.confirm({
    --   -- selects the first item if none are selected
    --   select = true,
    -- }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  -- show the source that created the completion item
  -- formatting = lsp_zero.cmp_format({ details = true }),
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

local ls = require("luasnip")
vim.keymap.set({ "i", "s" }, "<C-L>", function()
  ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function()
  ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- setup vim.dadbod
-- cmp.setup.filetype({ "sql" }, {
-- 	sources = {
-- 		{ name = "vim-dadbod-completion" },
-- 		{ name = "buffer" },
-- 	},
-- })

-- Setting up handlers.

local util = require("lspconfig.util")
local lspconfig = require("lspconfig")

lspconfig.ts_ls.setup({
  -- TODO: explore alternatives (https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/ts_ls.lua#L15).
  root_dir = util.root_pattern(".git"),
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if
      not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
    then
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            --									library = {
            --										vim.env.VIMRUNTIME
            --										-- "${3rd}/luv/library"
            --										-- "${3rd}/busted/library",
            --									}
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end,
  capabilities = capabilities,
})

lspconfig.html.setup({
  capabilities = capabilities,
})
lspconfig.cssls.setup({
  capabilities = capabilities,
})
lspconfig.clangd.setup({
  capabilities = capabilities,
})

lspconfig.jsonls.setup({
  -- Lazy-load schemastore when needed
  on_new_config = function(new_config)
    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
  end,
  settings = {
    json = {
      format = {
        enable = true,
      },
      validate = { enable = true },
    },
  },
  capabilities = capabilities,
})

lspconfig.gopls.setup({
  capabilities = capabilities,
})

lspconfig.bashls.setup({
  capabilities = capabilities,
})

lspconfig.yamlls.setup({
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = {
        ["kubernetes"] = "*.yaml",
      },
    },
  },
  capabilities = capabilities,
})
