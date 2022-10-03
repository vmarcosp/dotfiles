lua << END
local file_name =
  function ()
    if vim.bo.filetype == "NvimTree" then
      return "  Explorer"
    else 
      return " " .. vim.fn.expand('%:t')
    end
  end

require('lualine').setup({
 options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {file_name},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {'diagnostics'},
    lualine_z = {'filetype'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})
END

set laststatus=3
