local M = {}

M.plugins = {
  "rescript-lang/vim-rescript",
  "nkrkv/nvim-treesitter-rescript",
  "devongovett/tree-sitter-highlight",
}

M.mappings = {
  leader = "\\",
}

M.theme = {
  name = "catppuccin",
  catppuccin_flavour = "mocha",
}

M.flags = {
  format_on_save = true,
  disable_tabs = true
}

M.nvim_tree = {
  view = {
    adaptive_size = false
  }
}

M.lualine = {
  options = {
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  }
}

M.hooks = {
  after_setup = function()
    vim.cmd("set relativenumber")
  end
}

M.lsps = {
   ["rescriptls@latest-master"] = {},
}

return M
