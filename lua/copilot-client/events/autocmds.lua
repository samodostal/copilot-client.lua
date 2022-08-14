local ui = require("copilot-client.ui")
local keymaps = require("copilot-client.events.keymaps")

local M = {}

M.create_autocmds = function(opts)
	local augroup = vim.api.nvim_create_augroup(
		"CopilotClient",
		{ clear = true }
	)

	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		group = augroup,
		callback = function()
			keymaps.delete_keymaps(opts)
		end,
		once = true,
	})

	vim.api.nvim_create_autocmd(
		{ "InsertLeave", "TextChangedI", "CursorMovedI" },
		{
			group = augroup,
			callback = function()
				ui.clear_ghost_completion()
			end,
			once = true,
		}
	)
end

return M
