return {
  mappings = {
    leader = "\\",
  },
  plugins = {
    "rescript-lang/vim-rescript",
    "nkrkv/nvim-treesitter-rescript",
    "devongovett/tree-sitter-highlight",
  },
  lsps = {},
  theme = {
    name = "catppuccin",
    catppuccin_flavour = "macchiato",
  },
  flags = {
    format_on_save = true,
    disable_tabs = true
  },
  nvim_tree = {
    view = {
      adaptive_size = false
    }
  },
  lualine = {
    options = {
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
    }
  },
  hooks = {
    after_setup = function()
      vim.cmd("set relativenumber")
    end
  }
}
