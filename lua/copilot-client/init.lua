local async = require("plenary.async")

local config = require("copilot-client.config")
local api = require("copilot-client.api")
local ui = require("copilot-client.ui")
local keymaps = require("copilot-client.events.keymaps")
local autocmds = require("copilot-client.events.autocmds")

local M = {}

local suggested_completion = nil
local global_opts = nil

M.setup = function(user_opts)
	user_opts = user_opts or {}
	global_opts = vim.tbl_deep_extend("force", config.DEFAULT_OPTS, user_opts)

	ui.setup()
end

M.suggest = function()
	async.run(function()
		local is_insert_mode = vim.api.nvim_get_mode().mode == "i"
		if not is_insert_mode then
			print("You have to be in insert mode when calling 'suggest'")
			return
		end

		ui.show_copilot_waiting()

		local completions = api.get_completion() or {}
		if next(completions) == nil then
			ui.hide_copilot_waiting(false)
			return
		end

		-- TODO: Handle multiple completions
		local first_completion = completions[1]
		suggested_completion = first_completion

		ui.hide_copilot_waiting(true)
		ui.show_ghost_completion(first_completion)

		keymaps.create_keymaps(global_opts)
		autocmds.create_autocmds(global_opts)
	end)
end

M.accept = function()
	ui.insert_completion(suggested_completion)
	keymaps.delete_keymaps(global_opts)
end

M.suggest_next = function()
	print("'suggest_next' not yet implemented...")
end

M.suggest_prev = function()
	print("'suggest_prev' not yet implemented...")
end

return M
