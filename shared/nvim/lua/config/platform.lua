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

-- Written by macos/bin/theme.
function M.macos_theme_file()
	local state = vim.env.XDG_STATE_HOME or vim.fn.expand("~/.local/state")
	return state .. "/dotfiles/theme"
end

function M.macos_theme()
	local ok, lines = pcall(vim.fn.readfile, M.macos_theme_file(), "", 1)
	local name = ok and lines[1] and vim.trim(lines[1]) or ""
	return name ~= "" and name or "yugen"
end

return M
