return {
	'nvim-telescope/telescope.nvim', tag = '0.1.5',
	cmd = "Telescope",
	version = false,
	dependencies = {
		{ 'nvim-lua/plenary.nvim' },
		{ 'nvim-telescope/telescope-fzf-native.nvim',
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
		}
	},
	keys = {
		{
			"<leader>,",
			"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
			desc = "Switch Buffer",
		},
		-- { "<leader>/", Util.telescope("live_grep"), desc = "Grep (root dir)" },
		{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		-- { "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
		{ "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files (root dir)" },
		-- find
		{ "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
		-- { "<leader>fc", Util.telescope.config_files(), desc = "Find Config File" },
		-- { "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
		-- { "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
		{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
		-- { "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
		-- git
		{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
		{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
		-- search
		{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
		{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
		{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
		-- { "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
		-- { "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
		{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
		{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
		{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
		-- { "<leader>sw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
		-- { "<leader>sW", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
		-- { "<leader>sw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
		-- { "<leader>sW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
		-- { "<leader>uC", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
		{
			"<leader>ss",
			function()
				require("telescope.builtin").lsp_document_symbols()
			end,
			desc = "Goto Symbol",
		},
		{
			"<leader>sS",
			function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols()
			end,
			desc = "Goto Symbol (Workspace)",
		},
		{ "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
		{ "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition"  },
		{ "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
		{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
		{ "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
		{ "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
		{ "K", vim.lsp.buf.hover, desc = "Hover" },
		{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
		{ "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
		{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
		{
			"<leader>cA",
			function()
				vim.lsp.buf.code_action({
					context = {
						only = {
							"source",
						},
						diagnostics = {},
					},
				})
			end,
			desc = "Source Action",
		}
	},
	config = function()
		require('telescope').load_extension('fzf')
	end
}
