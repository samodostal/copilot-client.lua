local M = {}

M.create_keymaps = function(opts)
	vim.api.nvim_buf_set_keymap(
		0,
		"i",
		opts.mapping.accept,
		'<cmd>lua require("copilot-client").accept()<CR>',
		{ noremap = true, silent = false }
	)
end

-- PERF: Delete keymap if it exists without looking at all other buffer keymaps
M.delete_keymaps = function(opts)
	local buf_keymaps = vim.api.nvim_buf_get_keymap(0, "i")
	for _, keymap in pairs(buf_keymaps) do
		if keymap.lhs == opts.mapping.accept then
			vim.api.nvim_buf_del_keymap(0, "i", opts.mapping.accept)
			break
		end
	end
end

return M
