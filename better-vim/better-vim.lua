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

local setup_theme = function()
  require("catppuccin").setup({
    highlight_overrides = {
      all = function(colors)
        return {
          CurSearch = { bg = colors.sky },
          IncSearch = { bg = colors.sky },
          CursorLineNr = { fg = colors.blue, style = { "bold" } },
          DashboardFooter = { fg = colors.overlay0 },
          TreesitterContextBottom = { style = {} },
          WinSeparator = { fg = colors.overlay0, style = { "bold" } },
          ["@markup.italic"] = { fg = colors.blue, style = { "italic" } },
          ["@markup.strong"] = { fg = colors.blue, style = { "bold" } },
          Headline = { style = { "bold" } },
          Headline1 = { fg = colors.blue, style = { "bold" } },
          Headline2 = { fg = colors.pink, style = { "bold" } },
          Headline3 = { fg = colors.lavender, style = { "bold" } },
          Headline4 = { fg = colors.green, style = { "bold" } },
          Headline5 = { fg = colors.peach, style = { "bold" } },
          Headline6 = { fg = colors.flamingo, style = { "bold" } },
          rainbow1 = { fg = colors.blue, style = { "bold" } },
          rainbow2 = { fg = colors.pink, style = { "bold" } },
          rainbow3 = { fg = colors.lavender, style = { "bold" } },
          rainbow4 = { fg = colors.green, style = { "bold" } },
          rainbow5 = { fg = colors.peach, style = { "bold" } },
          rainbow6 = { fg = colors.flamingo, style = { "bold" } },
        }
      end,
    },
    color_overrides = {
      mocha = {
        rosewater = "#F5B8AB",
        flamingo = "#F29D9D",
        pink = "#AD6FF7",
        mauve = "#FF8F40",
        red = "#E66767",
        maroon = "#EB788B",
        peach = "#FAB770",
        yellow = "#FACA64",
        green = "#70CF67",
        teal = "#4CD4BD",
        sky = "#61BDFF",
        sapphire = "#4BA8FA",
        blue = "#A3AAC2",
        lavender = "#00BBCC",
        text = "#C1C9E6",
        subtext1 = "#A3AAC2",
        subtext0 = "#8E94AB",
        overlay2 = "#7D8296",
        overlay1 = "#676B80",
        overlay0 = "#464957",
        surface2 = "#3A3D4A",
        surface1 = "#2F313D",
        surface0 = "#1D1E29",
        base = "#0b0b12",
        mantle = "#11111a",
        crust = "#191926",
      },
    },
    integrations = {
      telescope = {
        enabled = true,
        style = "nvchad",
      },
    },
  })

  vim.cmd.colorscheme "catppuccin"
end

M.hooks = {
  after_setup = function()
    setup_theme()
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
