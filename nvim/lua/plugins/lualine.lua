return {
  'nvim-lualine/lualine.nvim',
  opts = {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },   
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = true,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'branch', 'diff', 'diagnostics'},
    lualine_y = {'filetype'},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}}
