lua << END
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { right = ' ' }, left_padding = 0 },
    },
    lualine_b = { 
      { 'filename', separator = { right = ' ' }, left_padding = 0 }, 
    },
    lualine_c = { '' },
    lualine_x = { '' },
    lualine_y = { 'diagnostics' },
    lualine_z = { 
      { 'progress', separator = { left = ' ' } },
    },  
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},  
  },
  tabline = {},
  extensions = { 'nvim-tree', 'fugitive' },
  options = {
     disabled_filetypes = {'NvimTree'}
   }
}
END
