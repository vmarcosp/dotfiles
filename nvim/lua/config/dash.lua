local M = {}

local function center_line(str)
	local width = vim.api.nvim_win_get_width(0)
	-- Calculate correct visual width by counting actual characters, not bytes
	local visual_width = 0
	for _ in str:gmatch("[^\128-\191]") do
		visual_width = visual_width + 1
	end
	local shift = math.floor((width - visual_width) / 2)
	return string.rep(" ", shift) .. str
end

local function get_git_branch()
	local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
	-- Check if we're in a git repository
	if vim.v.shell_error ~= 0 or branch == "" then
		return nil
	end
	return branch
end

-- Function to render branch info
local function render_branch()
	local branch = get_git_branch()
	if branch then
		return "󰘬 " .. branch
	else
		return ""
	end
end

-- Separate function to generate the final message
local function generate_message()
	local message = {}

	-- Greeting with wave emoji (centered)
	table.insert(message, " Hey there! 👋")

	-- Add two empty lines
	table.insert(message, "")
	table.insert(message, "")

	-- Add git branch info (centered)
	table.insert(message, render_branch())

	return message
end

-- Define custom highlight groups
local function setup_highlights()
	vim.cmd([[
		highlight DashboardGreeting guifg=#98C379 gui=bold
		highlight DashboardBranch guifg=#61AFEF gui=italic
	]])
end

function M.draw()
	vim.cmd("enew")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.bo.buflisted = false
	vim.bo.filetype = "my_dashboard" -- Set a custom filetype

	local buf = vim.api.nvim_get_current_buf()

	-- Setup custom highlight groups
	setup_highlights()

	-- Generate the message dynamically
	local message = generate_message()
	local padding_top = math.floor((vim.o.lines - #message) / 2)

	local lines = {}

	-- Add top padding
	for i = 1, padding_top do
		table.insert(lines, "")
	end

	-- Add each line, with all content centered
	for i, line in ipairs(message) do
		table.insert(lines, center_line(line))

		-- Apply highlight groups based on line content
		if i == 1 then -- Greeting line
			vim.api.nvim_buf_add_highlight(buf, -1, "DashboardGreeting", padding_top + i - 1, 0, -1)
		elseif i == #message then -- Branch line
			vim.api.nvim_buf_add_highlight(buf, -1, "DashboardBranch", padding_top + i - 1, 0, -1)
		end
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo.modifiable = false
	vim.api.nvim_buf_set_name(buf, "Home")

	vim.opt_local.number = false
	vim.opt_local.relativenumber = false
	vim.opt_local.cursorline = false
	vim.opt_local.signcolumn = "no"
	vim.opt_local.colorcolumn = ""
end

function M.setup()
	local augroup = vim.api.nvim_create_augroup("MessageDashboard", { clear = true })
	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		callback = function()
			if vim.fn.argc() == 0 then
				M.draw()
			end
		end,
	})
end

return M
