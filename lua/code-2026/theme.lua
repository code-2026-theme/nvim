local util = require 'code-2026.util'

local M = {}

local core_modules = { 'editor', 'syntax', 'treesitter', 'lsp' }

--- Build the full highlight table for a config.
---@param opts Dark2026Config
---@return table<string, table> highlights, table<string, string> colors
function M.build(opts)
  local colors = require('code-2026.palette').get(opts)
  local highlights = {}

  for _, name in ipairs(core_modules) do
    util.merge_highlights(highlights, require('code-2026.groups.' .. name).get(colors, opts))
  end

  local plugins = require('code-2026.groups.plugins').get(colors, opts)
  for name, groups in pairs(plugins) do
    if opts.plugins[name] ~= false then
      util.merge_highlights(highlights, groups)
    end
  end

  if type(opts.on_highlights) == 'function' then
    opts.on_highlights(highlights, colors)
  end

  util.merge_highlights(highlights, opts.highlights)

  return highlights, colors
end

return M
