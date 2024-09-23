-- File: lua/sneakpeak/init.lua

local M = {}

-- Store the floating window and buffer IDs
local float_win = nil
local float_buf = nil

-- Function to create or toggle the floating window
function M.toggle_sneakpeak()
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		-- If the window exists and is valid, focus it
		vim.api.nvim_set_current_win(float_win)
	else
		-- Create a new floating window
		local current_line = vim.api.nvim_get_current_line()
		float_buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { current_line })

		local width = vim.api.nvim_get_option("columns")
		local height = vim.api.nvim_get_option("lines")

		local win_height = math.ceil(height * 0.8 - 4)
		local win_width = math.ceil(width * 0.8)

		local row = math.ceil((height - win_height) / 2 - 1)
		local col = math.ceil((width - win_width) / 2)

		local opts = {
			style = "minimal",
			relative = "editor",
			width = win_width,
			height = win_height,
			row = row,
			col = col,
			border = "rounded",
		}

		float_win = vim.api.nvim_open_win(float_buf, true, opts)
		vim.api.nvim_win_set_option(float_win, "wrap", true)
	end
end

-- Function to set up the plugin
function M.setup(config)
	config = config or {}
	local keymap = config.keymap or "<C-k>"

	vim.keymap.set("n", keymap, M.toggle_sneakpeak, { silent = true, noremap = true })
end

return M
