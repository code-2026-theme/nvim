local config = require 'code-2026.config'

local M = {}

M.name = 'code-2026'

---@type Dark2026Config
M.options = nil

---@type integer?
M.sync_group = nil

--- Detect the OS color mode.
--- macOS: reads `AppleInterfaceStyle` from defaults.
--- Linux (GNOME): reads `org.gnome.desktop.interface color-scheme`.
--- Falls back to `'dark'` when detection is unavailable.
---@return "'dark'"|"'light'"
function M.detect_bg()
  if vim.fn.has 'mac' == 1 or vim.fn.has 'macunix' == 1 then
    local ok = pcall(vim.fn.system, { 'defaults', 'read', '-g', 'AppleInterfaceStyle' })
    if ok and vim.v.shell_error == 0 then
      return 'dark'
    end
    return 'light'
  end

  if vim.fn.has 'linux' == 1 then
    local ok, out = pcall(vim.fn.system, {
      'gsettings',
      'get',
      'org.gnome.desktop.interface',
      'color-scheme',
    })
    if ok and vim.v.shell_error == 0 and out:match 'prefer-dark' then
      return 'dark'
    end
    return 'light'
  end

  return 'dark'
end

--- Resolve `'auto'` / `'sync'` background values to a concrete `'dark'` or `'light'`.
--- Mutates `opts` in place and returns it.
---@param opts Dark2026Config
---@return Dark2026Config
local function resolve_bg(opts)
  if opts.background == 'auto' or opts.background == 'sync' then
    opts.background = M.detect_bg()
  end
  return opts
end

local function clear_sync()
  if M.sync_group then
    vim.api.nvim_del_augroup_by_id(M.sync_group)
    M.sync_group = nil
  end
end

local function apply_sync()
  clear_sync()
  M.sync_group = vim.api.nvim_create_augroup('code-2026-sync', { clear = true })
  vim.api.nvim_create_autocmd('FocusGained', {
    group = M.sync_group,
    callback = function()
      local detected = M.detect_bg()
      if detected ~= vim.o.background then
        M.load { background = detected }
        vim.api.nvim_exec_autocmds('ColorScheme', {
          pattern = vim.g.colors_name,
          modeline = false,
        })
      end
    end,
  })
end

--- Store user configuration. Reloads the colorscheme when it is already active.
--- When `background` is `'auto'` or `'sync'`, the OS color mode is detected and
--- resolved to `'dark'` or `'light'`.  `'sync'` additionally listens for
--- `FocusGained` events and re-applies the theme when the OS color mode changes.
---@param opts? Dark2026Config
function M.setup(opts)
  opts = vim.deepcopy(opts or {})

  local should_sync = opts.background == 'sync'

  -- Resolve auto/sync before config.extend() so validation sees dark/light.
  resolve_bg(opts)
  M.options = config.extend(opts)

  if should_sync then
    apply_sync()
  else
    clear_sync()
  end

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
    local merged = vim.tbl_deep_extend('force', M.options or {}, opts)
    resolve_bg(merged)
    return config.extend(merged)
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
