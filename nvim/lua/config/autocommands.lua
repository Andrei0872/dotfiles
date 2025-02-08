local autocmd = vim.api.nvim_create_autocmd

print("autocommands!")

autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- TODO: might want to remove this.
		-- Disable comment on new line
		vim.opt.formatoptions:remove { "c", "r", "o" }
	end,
	group = general,
	desc = "Disable New Line Comment",
})
