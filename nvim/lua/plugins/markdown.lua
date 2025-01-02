return {
	{
		"jakewvincent/mkdnflow.nvim",
		ft = { "markdown" },
		config = function()
			require("mkdnflow").setup({
				mappings = {
					MkdnEnter = { { "i", "n", "v" }, "<CR>" },
					MkdnNewListItem = { "i", "<CR>" },
				},
			})
		end,
	},
	{
		ft = { "markdown" },
		"antonk52/markdowny.nvim",
		config = function()
			require("markdowny").setup()
		end,
	},
}
