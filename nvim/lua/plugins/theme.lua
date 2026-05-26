local dotfiles = vim.fn.expand("~/projects/dotfiles")
local current_path = dotfiles .. "/themes/current.json"

local f = io.open(current_path, "r")
if not f then
	return { require("themes/yugen") }
end
local raw = f:read("*a")
f:close()

local ok, current = pcall(vim.fn.json_decode, raw)
if not ok or not current or not current.nvim or not current.nvim.module then
	return { require("themes/yugen") }
end

if current.nvim.background then
	vim.o.background = current.nvim.background
end

if type(current.nvim.options) == "table" then
	for k, v in pairs(current.nvim.options) do
		vim.g[k] = v
	end
end

local module = current.nvim.module:gsub("%.", "/")
return { require(module) }
