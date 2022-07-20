local copilot_server_util = require("copilot.util")

local M = {}

local namespace_id

M.setup = function()
	vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#808080" })
end

-- TODO: Show and hide copilot waiting as virtual dots animating (.) -> (..) -> (...)
M.show_copilot_waiting = function()
	print("Waiting for Copilot Language Server...")
end

M.hide_copilot_waiting = function(is_success)
	if is_success then
		print("Done!")
	else
		print("No completions found.")
	end
end

M.show_ghost_completion = function(completion)
	local display_text = completion.displayText

	local completion_params = copilot_server_util.get_completion_params()
	completion_params.doc.insertSpaces = false

	local lines = {}

	for s, _ in display_text:gmatch("[^\n]+") do
		table.insert(lines, {
			{
				s,
				"CopilotSuggestion",
			},
		})
	end

	-- BUG: This still doesn't work all the time
	local first_line = table.remove(lines, 1)
	if first_line[1][1]:find("^\t") ~= nil then
		first_line[1][1] = first_line[1][1]:sub(2)
	end

	local bnr = vim.fn.bufnr("%")
	namespace_id = vim.api.nvim_create_namespace("copilot-client")

	local line_num = completion_params.doc.position.line
	local col_num = completion_params.doc.position.character

	local opts = {
		id = 1,
		virt_text = first_line,
		virt_lines = lines,
		virt_text_pos = "overlay",
		virt_text_win_col = completion.position.character + 1,
		right_gravity = false,
	}

	vim.api.nvim_buf_set_extmark(bnr, namespace_id, line_num, col_num, opts)
end

M.clear_ghost_completion = function()
	vim.api.nvim_buf_clear_namespace(0, namespace_id, 0, -1)
end

M.insert_completion = function(completion)
	local display_text = completion.displayText

	local lines = {}
	for s, _ in display_text:gmatch("[^\n]+") do
		table.insert(lines, s)
	end

	if lines[1]:find("^\t") ~= nil then
		lines[1] = lines[1]:sub(2)
	end

	vim.api.nvim_buf_set_text(
		0,
		completion.position.line,
		completion.position.character,
		completion.position.line,
		completion.position.character,
		lines
	)
end

return M
