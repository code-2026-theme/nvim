local util = require 'code-2026.util'

local M = {}

--- Dark palette, ported from the VS Code "Dark Modern 2026" theme.
M.dark = {
  none = 'NONE',

  -- Backgrounds (darkest -> lightest)
  bg = '#121314', -- editor
  bg_alt = '#191a1b', -- sidebar / status / panel / inactive tabs
  bg_menu = '#202122', -- menu / quick input / floats
  bg_line = '#242526', -- line highlight, hover
  bg_widget = '#262728', -- widget hover
  bg_select = '#276782', -- selection
  bg_match = '#1e4252', -- dimmed selection (search matches)
  border = '#2a2b2c',
  border_alt = '#333536',

  -- Foregrounds
  fg = '#bbbebf',
  fg_alt = '#bfbfbf',
  fg_dim = '#8c8c8c',
  fg_muted = '#555555',
  white = '#ffffff',

  -- Accent (cyan/blue)
  accent = '#3994bc',
  accent_dim = '#297aa0',
  accent_alt = '#48a0c7',

  -- Syntax (Dark 2026 / GitHub Dark style -- red keywords, purple functions)
  comment = '#8b949e',
  string = '#a5d6ff',
  regex = '#7ee787',
  number = '#79c0ff',
  keyword = '#ff7b72', -- red
  func = '#d2a8ff', -- purple
  type = '#4ec9b0', -- teal/green
  variable = '#bbbebf', -- default fg (plain ident)
  constant = '#79c0ff',
  operator = '#ff7b72',
  preproc = '#ff7b72', -- return/import/throw -- red control flow
  annotation = '#ffa657',
  param = '#ffa657',
  member = '#79c0ff', -- field/property
  tag = '#7ee787',
  attr = '#79c0ff',
  module = '#4ec9b0', -- module/namespace
  macro = '#48a0c7', -- println!, eprintln!

  -- Diagnostics / status
  err = '#f44747',
  warn = '#cd9731',
  info = '#6796e6',
  hint = '#3a94bc',
  ok = '#7ee787',
  debug = '#b267e6',

  -- Diff
  diff_add = '#1b3a1b',
  diff_add_fg = '#7ee787',
  diff_del = '#3a1b1b',
  diff_del_fg = '#ffa198',
  diff_chg = '#2a2a4a',
  diff_chg_fg = '#79c0ff',
  diff_text = '#3a3a63',
}

--- Light palette, ported from the VS Code "2026 Light" theme.
M.light = {
  none = 'NONE',

  -- Backgrounds (lightest -> darkest)
  bg = '#FFFFFF', -- editor
  bg_alt = '#FAFAFD', -- sidebar / status / panel / inactive tabs
  bg_menu = '#FAFAFD', -- menu / quick input / floats
  bg_line = '#EAEAEA', -- line highlight, hover
  bg_widget = '#F0F0F3', -- widget hover
  bg_select = '#C2DAF5', -- selection (blended from #0069CC40 over white)
  bg_match = '#B3D7F2', -- dimmed selection (search matches)
  border = '#F0F1F2',
  border_alt = '#E4E5E6',

  -- Foregrounds
  fg = '#202020',
  fg_alt = '#1F1F1F',
  fg_dim = '#606060',
  fg_muted = '#999999',
  white = '#FFFFFF',

  -- Accent (blue)
  accent = '#0069CC',
  accent_dim = '#005FB8',
  accent_alt = '#0069CC',

  -- Syntax (2026 Light / GitHub Light style -- red keywords, purple functions)
  comment = '#6e7781',
  string = '#0a3069',
  regex = '#116329',
  number = '#0550ae',
  keyword = '#cf222e', -- red
  func = '#8250df', -- purple
  type = '#116329', -- green
  variable = '#202020', -- default fg (plain ident)
  constant = '#0550ae',
  operator = '#cf222e',
  preproc = '#cf222e', -- return/import/throw -- red control flow
  annotation = '#953800', -- orange/brown
  param = '#1f2328', -- near-black (VS Code light params)
  member = '#0550ae', -- field/property
  tag = '#116329',
  attr = '#0550ae',
  module = '#116329', -- module/namespace
  macro = '#953800', -- orange/brown

  -- Diagnostics / status
  err = '#ad0707',
  warn = '#667309',
  info = '#0069CC',
  hint = '#6e7781',
  ok = '#587c0c',
  debug = '#8250df',

  -- Diff
  diff_add = '#dafbe1',
  diff_add_fg = '#116329',
  diff_del = '#ffebe9',
  diff_del_fg = '#82071e',
  diff_chg = '#ffd8b5',
  diff_chg_fg = '#953800',
  diff_text = '#ddf4ff',
}

--- Backward-compatible alias.
M.base = M.dark

--- Resolve the palette for a config: base -> `palette` overrides -> derived
--- colors -> `on_colors`.
---@param opts Dark2026Config
---@return table<string, string>
function M.get(opts)
  opts = opts or require('code-2026.config').defaults

  local base = opts.background == 'light' and M.light or M.dark
  local c = vim.tbl_extend('force', vim.deepcopy(base), opts.palette or {})

  local floats = opts.styles.floats
  if floats == 'auto' then
    floats = opts.transparent and 'transparent' or 'solid'
  end

  -- Contextual backgrounds. Set them in `palette` to opt out of the derivation.
  c.bg_normal = c.bg_normal or (opts.transparent and c.none or c.bg)
  c.bg_panel = c.bg_panel or (opts.transparent and c.none or c.bg_alt)
  c.bg_float = c.bg_float or (floats == 'transparent' and c.none or c.bg_menu)
  if opts.transparent then
    c.bg_inactive = c.bg_inactive or c.none
  elseif opts.background == 'light' then
    c.bg_inactive = c.bg_inactive or util.blend(c.bg, c.bg_alt, 0.5)
  else
    c.bg_inactive = c.bg_inactive or util.darken(c.bg, 0.35)
  end

  -- Blended diagnostic backgrounds for virtual text.
  c.err_bg = c.err_bg or (opts.transparent and c.none or util.blend(c.err, c.bg, 0.12))
  c.warn_bg = c.warn_bg or (opts.transparent and c.none or util.blend(c.warn, c.bg, 0.12))
  c.info_bg = c.info_bg or (opts.transparent and c.none or util.blend(c.info, c.bg, 0.12))
  c.hint_bg = c.hint_bg or (opts.transparent and c.none or util.blend(c.hint, c.bg, 0.12))

  c.terminal = c.terminal
    or {
      [0] = c.bg_menu,
      [1] = c.keyword,
      [2] = c.regex,
      [3] = c.warn,
      [4] = c.number,
      [5] = c.func,
      [6] = c.type,
      [7] = c.fg,
      [8] = c.fg_muted,
      [9] = c.diff_del_fg,
      [10] = util.lighten(c.regex, 0.15),
      [11] = c.annotation,
      [12] = c.string,
      [13] = c.debug,
      [14] = util.lighten(c.type, 0.2),
      [15] = c.white,
    }

  if type(opts.on_colors) == 'function' then
    opts.on_colors(c)
  end

  return c
end

return M
