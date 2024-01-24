return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local util = require("lspconfig.util")
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "tsserver" }
			})

			require'lspconfig'.lua_ls.setup{
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
						client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
							Lua = {
								runtime = {
									version = 'LuaJIT'
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
									library = vim.api.nvim_get_runtime_file("", true)
								}
							}
						})

						client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
					end
					return true
				end,
				capabilities = capabilities
			}

			require'lspconfig'.tsserver.setup{
				root_dir = util.root_pattern(".git"),
				capabilities = capabilities
			}
		end
	}
}
