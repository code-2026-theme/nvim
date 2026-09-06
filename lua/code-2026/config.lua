local M = {}

---@class Dark2026Style
---@field bold? boolean
---@field italic? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field strikethrough? boolean

---@class Dark2026Config
M.defaults = {
  --- Background variant.
  --- - `'dark'` / `'light'`: fixed variant.
  --- - `'auto'`: detect OS color mode once at `setup()` and stay fixed.
  --- - `'sync'`: detect OS color mode at `setup()` and re-apply whenever it changes.
  ---@type "'dark'"|"'light'"|"'auto'"|"'sync'"
  background = 'dark',
  --- Transparent editor background (`Normal`, gutters, statusline, tabline).
  transparent = false,
  --- Set `vim.g.terminal_color_*` from the palette.
  terminal_colors = true,
  --- Darken windows that are not focused (`NormalNC`).
  dim_inactive = false,

  --- Per-token styling. Every entry is merged into the highlight spec of the
  --- groups belonging to that semantic token, so `{ bold = true }` adds bold and
  --- `{ italic = false }` removes an italic set by the theme.
  styles = {
    comments = { italic = true },
    keywords = {},
    conditionals = {},
    functions = {},
    methods = {},
    variables = {},
    builtins = { italic = true },
    parameters = {},
    properties = {},
    types = {},
    strings = {},
    numbers = {},
    booleans = {},
    constants = {},
    operators = {},
    namespaces = {},
    macros = {},
    attributes = {},
    tags = {},
    headings = { bold = true },

    --- Floating windows / popups: "auto" follows `transparent`,
    --- "solid" always paints them, "transparent" never does.
    ---@type "auto"|"solid"|"transparent"
    floats = 'solid',
  },

  --- Static palette overrides, applied before `on_colors`.
  ---@type table<string, string>
  palette = {},

  --- Programmatic palette override. Mutate `colors` in place.
  ---@type fun(colors: table<string, string>)
  on_colors = function(colors) end,

  --- Programmatic highlight override. Mutate `highlights` in place; `colors` is
  --- the final palette.
  ---@type fun(highlights: table<string, table>, colors: table<string, string>)
  on_highlights = function(highlights, colors) end,

  --- Static highlight overrides, merged last (per group; `link` replaces).
  ---@type table<string, table>
  highlights = {},

  --- Disable groups for a plugin with `{ telescope = false }`. Unlisted plugins
  --- stay enabled. See `lua/code-2026/groups/plugins.lua` for the keys.
  ---@type table<string, boolean>
  plugins = {},
}

local function warn(msg)
  vim.notify('[code-2026] ' .. msg, vim.log.levels.WARN)
end

---@param opts? Dark2026Config
---@return Dark2026Config
function M.extend(opts)
  opts = opts or {}

  for key in pairs(opts) do
    if M.defaults[key] == nil then
      warn(('unknown option %q'):format(tostring(key)))
    end
  end

  local config = vim.tbl_deep_extend('force', vim.deepcopy(M.defaults), opts)

  local valid_bg = { dark = true, light = true, auto = true, sync = true }
  if not valid_bg[config.background] then
    warn(('background must be "dark", "light", "auto" or "sync", got %q'):format(tostring(config.background)))
    config.background = 'dark'
  end

  local floats = config.styles.floats
  if floats ~= 'auto' and floats ~= 'solid' and floats ~= 'transparent' then
    warn(('styles.floats must be "auto", "solid" or "transparent", got %q'):format(tostring(floats)))
    config.styles.floats = 'auto'
  end

  return config
end

return M
