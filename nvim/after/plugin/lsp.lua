local lsp = vim.lsp
local tele = require("telescope.builtin")

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"clangd",
		"eslint_d",
		"gopls",
		"jsonls",
		"lua_ls",
		"marksman",
		"rust_analyzer",
		"svelte",
		"taplo",
		"ts_ls",
		"yamlls",
		"html"
	},
	handlers = {
		-- lsp_zero.default_setup,
		-- lua_ls = function()
		-- 	local lua_opts = lsp_zero.nvim_lua_ls()
		-- 	require("lspconfig").lua_ls.setup(lua_opts)
		-- end,
		html = function()
			require("lspconfig").html.setup({
				filetypes = { "html", "templ", },
			})
		end
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

-- Useful lsp actions
map("n", "<leader>rn", lsp.buf.rename, "[R]e[N]ame")
map("n", "<leader>ca", lsp.buf.code_action, "[C]ode [A]ction")

-- File navigation
map("n", "<leader>o", "<cmd>AerialToggle!<cr>", "[O]utline")

-- Diagnostics
map("n", "gl", vim.diagnostic.open_float, "Open diagnostic float")
map("n", "]d", vim.diagnostic.goto_next, "Jump to the next diagnostic")
map("n", "[d", vim.diagnostic.goto_prev, "Jump to the previous diagnostic")

-- search symbols
map("n", "<leader>Sd", require("telescope.builtin").lsp_document_symbols, "[S]ymbols: [D]ocument")
map("n", "<leader>Sw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[S]ymbols: [W]orkspace")

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
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "luasnip", keyword_length = 2 },
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping(select_next),
		["<C-j>"] = cmp.mapping(select_next),
		["<C-p>"] = cmp.mapping(select_prev),
		["<C-k>"] = cmp.mapping(select_prev),
		["<C-y>"] = cmp.mapping.confirm({
			-- selects the first item if none are selected
			select = true,
		}),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
	}),
	-- makes the windows bordered so that they clearly float on top of the editor
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	-- show the source that created the completion item
	-- formatting = lsp_zero.cmp_format({ details = true }),
})

-- setup vim.dadbod
-- cmp.setup.filetype({ "sql" }, {
-- 	sources = {
-- 		{ name = "vim-dadbod-completion" },
-- 		{ name = "buffer" },
-- 	},
-- })

local util = require("lspconfig.util")

require'lspconfig'.ts_ls.setup{
	-- TODO: explore alternatives (https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/ts_ls.lua#L15).
	root_dir = util.root_pattern(".git"),
}
