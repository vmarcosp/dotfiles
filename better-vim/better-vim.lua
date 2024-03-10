local M = {}
local utils = require "better-vim-utils"

local Themes = {}

Themes.poimandres = {
  'olivercederborg/poimandres.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('poimandres').setup {}
    vim.cmd("colorscheme poimandres")
  end,
}

M.plugins = {
  "github/copilot.vim",
  "rescript-lang/vim-rescript",
  "devongovett/tree-sitter-highlight",
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
  },
}

M.theme = {
  name = "nord",
}

local Terminals = {}

Terminals.floating_window_opts = {
  border = 'curved',
  width = 124,
  height = 16,
  winblend = 3,
  zindex = 999,
}

Terminals.lazygit = {
  cmd = "lazygit",
  direction = "float",
  float_opts = Terminals.floating_window_opts,
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  on_close = function()
    vim.cmd("startinsert!")
  end,
}

Terminals.default = {
  direction = "float",
  float_opts = Terminals.floating_window_opts,
}

M.mappings = {
  leader = "\\",
  custom = {
    ["<leader>gt"] = {
      function()
        local terminal = require('toggleterm.terminal').Terminal
        terminal:new(Terminals.lazygit):toggle()
      end,
      'Open lazygit'
    },
    ["<leader>t"] = {
      function()
        local terminal = require('toggleterm.terminal').Terminal
        terminal:new(Terminals.default):toggle()
      end,
      'Open terminal'
    },
    ["<s-k>"] = { "5kzz", "Jump 5 lines above" },
    ["<s-j>"] = { "5jzz", "Jump 5 lines below" },
  }
}

M.flags = {
  disable_auto_theme_loading = false,
  format_on_save = true,
  disable_tabs = true
}

M.lualine = {
  options = {
    globalstatus = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    a = { "mode" },
    b = { "branch" },
    c = { utils.statusline.get_file_name },
    z = { "filetype" },
  }
}

M.hooks = {
  after_setup = function()
    require("nvim-web-devicons").set_icon {
      toml = {
        icon = "󰅪",
        name = "TOML"
      }
    }
    -- Remove the ~ from empty lines
    vim.opt.fillchars = { eob = ' ' }
    vim.o.relativenumber = 1
    -- Syntax highlight support for MDX
    vim.filetype.add({
      extension = {
        mdx = 'mdx',
      }
    })
    vim.treesitter.language.register('markdown', 'mdx')
    vim.treesitter.language.register('bash', 'sh')
  end
}

M.lsps = {
  bashls = {},
  ocamllsp = {},
  rescriptls = {},
  graphql = {}
}
M.treesitter = { "javascript", "typescript", "lua", "bash", "ocaml" }
M.unload_plugins = { "noice" }

return M
