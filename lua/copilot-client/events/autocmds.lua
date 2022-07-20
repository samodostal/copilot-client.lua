local ui = require("copilot-client.ui")
local keymaps = require("copilot-client.events.keymaps")

local M = {}

M.create_autocmds = function(opts)
	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		callback = function()
			keymaps.delete_keymaps(opts)
		end,
		once = true,
	})

	vim.api.nvim_create_autocmd(
		{ "InsertLeave", "TextChangedI", "CursorMovedI" },
		{
			callback = function()
				ui.clear_ghost_completion()
			end,
			once = true,
		}
	)
end

return M
