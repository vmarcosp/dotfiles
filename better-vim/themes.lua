local M = {}

M.poimandres = {
  'olivercederborg/poimandres.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('poimandres').setup {}
  end,

  init = function()
    vim.cmd("colorscheme poimandres")
  end
}

return M
