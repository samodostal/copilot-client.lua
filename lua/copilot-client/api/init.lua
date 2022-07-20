local async = require("plenary.async.async")
local copilot_server_util = require("copilot.util")

local M = {}

M.get_completion = function()
	local client = vim.lsp.get_active_clients({ name = "copilot" })
	if not client then
		print("Copilot client not attached, check :LspInfo")
		return
	end

	local completion_params = copilot_server_util.get_completion_params()
	completion_params.doc.insertSpaces = false

	local result = async.wrap(vim.lsp.buf_request_all, 4)(
		0,
		"getCompletionsCycling",
		completion_params
	)

	local completions = {}

	for _, part in ipairs(result) do
		if part.result ~= nil then
			table.insert(completions, part.result.completions[1])
		end
	end

	return completions
end

return M
