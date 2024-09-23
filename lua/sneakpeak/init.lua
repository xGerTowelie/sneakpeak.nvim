local M = {}

-- Store the floating window and buffer IDs
local float_win = nil
local float_buf = nil

-- Store the current line number to detect movement
local current_line = nil

-- Function to create the floating window
function M.create_sneakpeak()
	-- Create a new floating window
	local line_content = vim.api.nvim_get_current_line()
	current_line = vim.fn.line(".")
	float_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { line_content })

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
		focusable = false, -- Make the window non-focusable initially
	}

	float_win = vim.api.nvim_open_win(float_buf, false, opts)
	vim.api.nvim_win_set_option(float_win, "wrap", true)

	-- Set up autocommand to close the window on cursor move
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		callback = function()
			if vim.fn.line(".") ~= current_line then
				M.close_sneakpeak()
			end
		end,
	})
end

-- Function to close the floating window
function M.close_sneakpeak()
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		vim.api.nvim_win_close(float_win, true)
		float_win = nil
		float_buf = nil
		current_line = nil
	end
end

-- Function to focus the floating window
function M.focus_sneakpeak()
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		vim.api.nvim_win_set_config(float_win, { focusable = true })
		vim.api.nvim_set_current_win(float_win)
	end
end

-- Function to toggle the sneakpeak window
function M.toggle_sneakpeak()
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		M.focus_sneakpeak()
	else
		M.create_sneakpeak()
	end
end

-- Function to set up the plugin
function M.setup(config)
	config = config or {}
	local keymap = config.keymap or "<C-k>"

	vim.keymap.set("n", keymap, M.toggle_sneakpeak, { silent = true, noremap = true })
end

return M
