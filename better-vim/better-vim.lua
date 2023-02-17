return {
  mappings = {
    leader = "\\",
  },
  theme = {
    name = "nordfox",
    catppuccin_flavour = "mocha",
    rose_pine = {},
    nightfox = {}
  },
  flags = {
    disable_tabs = true
  },
  nvim_tree = {
    view = {
		  hide_root_folder = true,
      adaptive_size = true
    }
  },
  lualine = {
    options = {
      component_separators = { left = '', right = ''},
      section_separators = { left = '' , right = ''}
    }
  }
}
