local M = {}
local function center_line(str)
	local width = vim.api.nvim_win_get_width(0)
	local shift = math.floor((width - #str) / 2)
	return string.rep(" ", shift) .. str
end
local message = {
	"",
	"",
	"**",
	"",
	"",
}
function M.draw()
	vim.cmd("enew")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.bo.buflisted = false
	vim.bo.filetype = "my_dashboard" -- Set a custom filetype
	local buf = vim.api.nvim_get_current_buf()
	local padding_top = math.floor((vim.o.lines - #message) / 2)
	local lines = {}
	for _ = 1, padding_top do
		table.insert(lines, "")
	end
	for _, line in ipairs(message) do
		table.insert(lines, center_line(line))
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
