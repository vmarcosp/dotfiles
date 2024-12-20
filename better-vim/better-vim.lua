local M = {}
local utils = require "better-vim-utils"

M.plugins = {
  "rescript-lang/vim-rescript",
  "devongovett/tree-sitter-highlight",
  "fladson/vim-kitty",
  "nvim-pack/nvim-spectre",
  "rescript-lang/tree-sitter-rescript",
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
  },
  {
    'bettervim/yugen.nvim',
    config = function()
      vim.cmd.colorscheme('yugen')
    end,
  }
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
    {
      "<leader>gt",
      function()
        local terminal = require('toggleterm.terminal').Terminal
        terminal:new(Terminals.lazygit):toggle()
      end,
      desc = 'Open lazygit'
    },
    {
      "<leader>t",
      function()
        local terminal = require('toggleterm.terminal').Terminal
        terminal:new(Terminals.default):toggle()
      end,
      desc = 'Open terminal'
    },
    { "<leader>ff", "<cmd>Format<cr>" },
    { "<s-k>", "5kzz", desc = "Jump 5 lines above" },
    { "<s-j>", "5jzz", desc = "Jump 5 lines below" },
  }
}

M.flags = {
  disable_auto_theme_loading = true,
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
    vim.opt.mouse:remove("a")
    require("nvim-web-devicons").set_icon {
      toml = {
        icon = "󰅪",
        name = "TOML"
      }
    }
    -- Remove the ~ from empty lines
    vim.opt.fillchars = { eob = ' ' }
    vim.o.relativenumber = true
    -- Syntax highlight support for MDX
    vim.filetype.add({
      extension = {
        mdx = 'mdx',
      }
    })
    vim.treesitter.language.register('markdown', 'mdx')
    vim.treesitter.language.register('bash', 'sh')
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.rescript = {
      install_info = {
        url = "https://github.com/rescript-lang/tree-sitter-rescript",
        branch = "main",
        files = { "src/scanner.c" },
        generate_requires_npm = false,
        requires_generate_from_grammar = true,
        use_makefile = true, -- macOS specific instruction
      },
    }
  end
}

M.lsps = {
  bashls = {},
  rescriptls = {},
  graphql = {},
  tailwindcss = {},
  cssls = {},
  cssmodules_ls = {},
  biome = {},
  rust_analyzer = {},
  ocamllsp = {}
}
M.treesitter = { "javascript", "typescript", "lua", "bash", "ocaml", "rust" }
M.unload_plugins = { "noice" }

return M
