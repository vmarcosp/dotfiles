--[[ require 'yugem.highlights' ]]
local utils = require 'yugem.utils'

local M = {}

local config = {
  bold_vert_split = false,
  dark_variant = 'main',
  disable_background = false,
  disable_float_background = false,
  disable_italics = false,
  dim_nc_background = false,

  groups = {
    background = 'color800',
    panel = 'color800',
    border = 'color600',
    comment = 'color500',
    link = 'color200',
    punctuation = 'color500',

    error = 'error',
    hint = 'success',
    info = 'color200',
    warn = 'warning',

    git_add = 'color200',
    git_change = 'color600',
    git_delete = 'color200',
    git_dirty = 'color200',
    git_ignore = 'color600',
    git_merge = 'color200',
    git_rename = 'color200',
    git_stage = 'color200',
    git_text = 'color200',

    headings = {
      h1 = 'teal2',
      h2 = 'yellow',
      h3 = 'pink3',
      h4 = 'pink2',
      h5 = 'blue1',
      h6 = 'blue2',
    },
  },
  highlight_groups = {},
}

function M.setup(opts)
  opts = opts or {}
  -- vim.g.yugem_variant = opts.dark_variant or 'main'

  if opts.groups and type(opts.groups.headings) == 'string' then
    opts.groups.headings = {
      h1 = opts.groups.headings,
      h2 = opts.groups.headings,
      h3 = opts.groups.headings,
      h4 = opts.groups.headings,
      h5 = opts.groups.headings,
      h6 = opts.groups.headings,
    }
  end

  config.user_variant = opts.dark_variant or nil
  config = vim.tbl_deep_extend('force', config, opts)
end

function M.colorscheme()
  if vim.g.colors_name then
    vim.cmd 'hi clear'
  end

  vim.opt.termguicolors = true
  vim.g.colors_name = 'yugem'

  local theme = require('yugem.theme').get(config)

  -- Set theme highlights
  for group, color in pairs(theme) do
    -- Skip highlight group if user overrides
    if config.highlight_groups[group] == nil then
      utils.highlight(group, color)
    end
  end

  -- Set user highlights
  for group, color in pairs(config.highlight_groups) do
    utils.highlight(group, color)
  end
end

return M
