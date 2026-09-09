local M = {}

function M.is_omarchy()
	return vim.fn.isdirectory("/usr/share/omarchy") == 1 or vim.fn.executable("omarchy") == 1
end

function M.omarchy_theme_lua()
	local state = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")
	if vim.fn.filereadable(state) == 1 then
		return state
	end
	local legacy = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
	if vim.fn.filereadable(legacy) == 1 then
		return legacy
	end
	return state
end

return M
