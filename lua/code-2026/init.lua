local config = require 'code-2026.config'

local M = {}

M.name = 'code-2026'

---@type Dark2026Config
M.options = nil

--- Store user configuration. Reloads the colorscheme when it is already active.
---@param opts? Dark2026Config
function M.setup(opts)
  M.options = config.extend(opts)
  local current = vim.g.colors_name
  if current == 'code-2026-dark' or current == 'code-2026-light' then
    M.load()
    -- Let statuslines and other consumers pick the new colors up.
    vim.api.nvim_exec_autocmds('ColorScheme', { pattern = current, modeline = false })
  end
end

---@param opts? Dark2026Config
---@return Dark2026Config
local function resolve(opts)
  if opts then
    return config.extend(vim.tbl_deep_extend('force', M.options or {}, opts))
  end
  return M.options or config.extend {}
end

--- Resolved palette, useful for statusline themes and `on_highlights` consumers.
---@param opts? Dark2026Config
---@return table<string, string>
function M.colors(opts)
  return require('code-2026.palette').get(resolve(opts))
end

--- Build (but do not apply) the highlight table.
---@param opts? Dark2026Config
---@return table<string, table>, table<string, string>
function M.highlights(opts)
  return require('code-2026.theme').build(resolve(opts))
end

--- Apply the colorscheme.
---@param opts? Dark2026Config
function M.load(opts)
  local options = resolve(opts)

  if vim.g.colors_name then
    vim.cmd 'highlight clear'
  end
  if vim.fn.exists 'syntax_on' == 1 then
    vim.cmd 'syntax reset'
  end

  vim.o.termguicolors = true
  vim.o.background = options.background
  vim.g.colors_name = 'code-2026-' .. options.background

  local highlights, colors = require('code-2026.theme').build(options)

  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  if options.terminal_colors then
    for i = 0, 15 do
      vim.g['terminal_color_' .. i] = colors.terminal[i]
    end
  end
end

return M
