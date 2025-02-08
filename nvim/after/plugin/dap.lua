local dap = require("dap")
local dapui = require("dapui")
local utils = require("dap.utils")

-- Set logging levels to debug why adapters are not working
-- logs are saved in ~.cache/nvim/dap.log
dap.set_log_level("DEBUG")

dap.adapters = {
	["pwa-node"] = {
		type = "server",
		port = "${port}",
		executable = {
			command = "js-debug-adapter",
			args = {
				"${port}",
			},
		},
	},
	["codelldb"] = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
			args = { "--port", "${port}" },
		},
	},
}

for _, language in ipairs({ "typescript", "javascript" }) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach to process ID",
			processId = utils.pick_process,
			cwd = "${workspaceFolder}",
		}
	}
end

dap.configurations.rust = {
	{
		type = "codelldb",
		request = "launch",
		name = "Launch file",
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
	},
}

dapui.setup({
	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
	controls = {
		icons = {
			pause = "⏸",
			play = "▶",
			step_into = "⏎",
			step_over = "⏭",
			step_out = "⏮",
			step_back = "b",
			run_last = "▶▶",
			terminate = "⏹",
			disconnect = "⏏",
		},
	},
})

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

local map = function(keys, func, desc)
	if desc then
		desc = "De[B]ugger: " .. desc
	end
	if keys then
		keys = "<leader>b" .. keys
	end
	vim.keymap.set("n", keys, func, { desc = desc })
end

map("s", dap.continue, "[S]tart/Continue")
map("i", dap.step_into, "Step [I]nto")
map("v", dap.step_over, "Step O[V]er")
map("o", dap.step_out, "Step [O]ut")
map("b", dap.toggle_breakpoint, "Toggle [B]reakpoint")
map("B", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Set [B]reakpoint")

map("u", function()
	dapui.toggle({
		-- Always open the nvim dap ui in the default sizes
		reset = true,
	})
end, "Toggle [U]I")
