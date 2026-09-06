---
title: "Light Variant Implementation Plan for dark-2026 Neovim Colorscheme"
version: "1.0"
date_created: "2026-09-05"
owner: "dark-2026 maintainer"
tags: ["design", "neovim", "colorscheme", "light-variant"]
---

# Introduction

This specification defines the implementation plan for adding a light theme variant to the dark-2026 Neovim colorscheme. The light variant will be based on VS Code's 2026 Light theme and will reuse the existing highlight group infrastructure, requiring only a new palette and entry point.

## 1. Purpose & Scope

**Purpose**: Add a `light-2026` colorscheme variant that maps VS Code 2026 Light colors to the existing palette key structure, enabling a light theme with zero changes to highlight group definitions.

**Scope**:
- New `background` config option (`'light'|'dark'`, default `'dark'`)
- New entry point `colors/light-2026.lua`
- New `M.light` palette table in `palette.lua`
- Conditional palette selection in `palette.get()`
- Updated `init.lua` to set `vim.o.background` from config
- Updated lualine theme to work with both variants
- Backward compatibility: existing `dark-2026` usage unchanged

**Assumptions**:
- All existing group files (`editor.lua`, `syntax.lua`, `treesitter.lua`, `lsp.lua`, `plugins.lua`) reference palette keys, not hardcoded colors
- The palette key names are semantically meaningful (e.g., `keyword` for keywords, `func` for functions), not color-specific
- The light palette can be derived by mapping VS Code 2026 Light hex values to the same key names

## 2. Definitions

| Term | Definition |
|------|-----------|
| **Palette** | A table of named color keys (e.g., `bg`, `fg`, `keyword`) used by all highlight group modules |
| **Entry point** | A file under `colors/` that Neovim's `:colorscheme` command loads |
| **Background mode** | The `vim.o.background` setting (`'dark'` or `'light'`) |
| **VS Code 2026 Light** | The reference light theme from VS Code's built-in theme collection |

## 3. Requirements, Constraints & Guidelines

### Requirements

- **REQ-001**: Add a `background` option to `config.lua` with type `'light'|'dark'`, default `'dark'`
- **REQ-002**: Create `colors/light-2026.lua` entry point that loads the light variant
- **REQ-003**: Add `M.light` palette table in `palette.lua` with all keys matching the existing `M.base` structure
- **REQ-004**: Modify `palette.get()` to select `M.dark` or `M.light` based on `opts.background`
- **REQ-005**: Modify `init.lua` `load()` to set `vim.o.background` from resolved config
- **REQ-006**: Rename existing `M.base` to `M.dark` (alias for backward compat)
- **REQ-007**: Lualine theme must work with both palettes (no changes needed since it uses `require('dark-2026').colors()`)
- **REQ-008**: All group files must work with both palettes without modification (they already use palette keys)
- **REQ-009**: `vim.g.colors_name` must be `'dark-2026'` for dark and `'light-2026'` for light
- **REQ-010**: Terminal colors must work correctly for both variants

### Constraints

- **CON-001**: No changes to group files (`editor.lua`, `syntax.lua`, `treesitter.lua`, `lsp.lua`, `plugins.lua`) - they must remain palette-key-agnostic
- **CON-002**: The existing `M.base` palette must be preserved as `M.dark` for backward compatibility with any external code referencing `palette.base`
- **CON-003**: Default behavior must remain dark (no breaking changes for existing users)
- **CON-004**: The `palette` override option must work for both variants (user can override light palette colors)

### Guidelines

- **GUD-001**: Derive contextual backgrounds (`bg_normal`, `bg_panel`, `bg_float`, etc.) from base colors in `palette.get()`, not in the palette table itself
- **GUD-002**: Use `util.blend()` and `util.lighten()` for derived colors, not hardcoded hex values
- **GUD-003**: Keep the light palette as close to VS Code 2026 Light as possible, adjusting only where Neovim semantics require it

## 4. Interfaces & Data Contracts

### Config Interface

```lua
---@class Dark2026Config
M.defaults = {
  --- Background mode: 'light' or 'dark'. Default: 'dark'
  background = 'dark',  -- NEW
  
  --- All existing options remain unchanged
  transparent = false,
  terminal_colors = true,
  dim_inactive = false,
  styles = { ... },
  palette = {},
  on_colors = function(colors) end,
  on_highlights = function(highlights, colors) end,
  highlights = {},
  plugins = {},
}
```

### Palette Interface

```lua
local M = {}

--- Dark palette (renamed from M.base)
M.dark = {
  none = 'NONE',
  bg = '#121314',
  -- ... all existing dark colors ...
}

--- Light palette (NEW)
M.light = {
  none = 'NONE',
  bg = '#FFFFFF',
  -- ... all light colors (see Section 9) ...
}

--- Backward-compatible alias
M.base = M.dark

--- Resolve palette for config
---@param opts Dark2026Config
---@return table<string, string>
function M.get(opts)
  -- Select base palette based on background
  local base = (opts.background == 'light') and M.light or M.dark
  local c = vim.tbl_extend('force', vim.deepcopy(base), opts.palette or {})
  -- ... derive contextual colors ...
  return c
end
```

### Entry Points

| File | Behavior |
|------|----------|
| `colors/dark-2026.lua` | Sets `background='dark'` in config, loads theme |
| `colors/light-2026.lua` | Sets `background='light'` in config, loads theme |

### Lualine Theme

```lua
-- lua/lualine/themes/dark-2026.lua (NO CHANGES NEEDED)
local c = require('dark-2026').colors()
-- Uses palette keys, works for both variants automatically
```

## 5. Acceptance Criteria

- **AC-001**: Given a user runs `:colorscheme dark-2026`, when the theme loads, then `vim.o.background` is `'dark'` and the dark palette is used
- **AC-002**: Given a user runs `:colorscheme light-2026`, when the theme loads, then `vim.o.background` is `'light'` and the light palette is used
- **AC-003**: Given `background = 'light'` in setup config, when any colorscheme loads, then the light palette is used
- **AC-004**: Given `background = 'dark'` (or omitted) in setup config, when any colorscheme loads, then the dark palette is used
- **AC-005**: Given the light variant, when editor groups load, then `Normal` has `bg = '#FFFFFF'` and `fg = '#202020'`
- **AC-006**: Given the light variant, when syntax groups load, then `Keyword` has `fg = '#cf222e'` (VS Code red)
- **AC-007**: Given the light variant, when lualine loads, then it uses the light palette colors
- **AC-008**: Given existing users with no `background` config, when they upgrade, then behavior is unchanged (dark variant)
- **AC-009**: Given the light variant, when terminal colors are set, then they use the light palette
- **AC-010**: Given user overrides via `palette = { bg = '#F0F0F0' }`, when the light variant loads, then the override is applied

## 6. Test Automation Strategy

### Test Levels

- **Manual visual testing**: Load each variant and verify colors in a terminal
- **Automated highlight verification**: Use Neovim's `nvim_get_hl()` to verify specific highlight groups have expected colors
- **Regression testing**: Ensure dark variant is unchanged

### Test Approach

```lua
-- tests/light_palette_spec.lua (suggested)
describe("light-2026 palette", function()
  it("loads light palette when background='light'", function()
    local palette = require('dark-2026.palette')
    local config = { background = 'light', styles = { floats = 'solid' } }
    local colors = palette.get(config)
    assert.equals('#FFFFFF', colors.bg)
    assert.equals('#202020', colors.fg)
  end)
  
  it("loads dark palette when background='dark'", function()
    local palette = require('dark-2026.palette')
    local config = { background = 'dark', styles = { floats = 'solid' } }
    local colors = palette.get(config)
    assert.equals('#121314', colors.bg)
  end)
end)
```

### CI/CD Integration

- Neovim headless mode: `nvim --headless -c "colorscheme light-2026" -c "lua print(vim.o.background)" -c "qa"`
- Verify output is `light`
- Check `vim.g.colors_name == 'light-2026'`

## 7. Rationale & Context

**Why rename `M.base` to `M.dark`?**
- Semantic clarity: the table contains dark colors, not a "base" that is overridden
- The `M.base` alias preserves backward compatibility for any code that references `palette.base`
- Enables clean `M.light` counterpart

**Why add `background` to config instead of auto-detecting?**
- User may have system-wide `vim.o.background` set for other reasons
- Explicit config is more predictable
- `colorscheme` command can override (entry point sets it)

**Why no changes to group files?**
- The existing architecture already uses palette keys exclusively
- This is the key design decision that makes the light variant trivial to add
- Any group file that hardcodes a color would need fixing (none do)

**Why keep `vim.g.colors_name` different per variant?**
- Neovim uses this to identify the active colorscheme
- Statusline plugins and other consumers check this value
- Enables `vim.g.colors_name == 'light-2026'` checks in user config

## 8. Dependencies & External Integrations

### External References

- **VS Code 2026 Light Theme**: Source of color values for the light palette
  - UI colors: `2026-light.json` (editor.background, sidebar.background, etc.)
  - Syntax colors: `tokenColors` section (keywords, functions, strings, etc.)
  - Diagnostic colors: error, warning, info, ok values
  - Diff colors: added/deleted/changed backgrounds and foregrounds

### Internal Dependencies

- **dark-2026/util.lua**: Color math helpers (`blend`, `darken`, `lighten`) - no changes needed
- **dark-2026/groups/*.lua**: All group modules - no changes needed (palette-key-agnostic)
- **lualine/themes/dark-2026.lua**: Statusline theme - no changes needed (uses `require('dark-2026').colors()`)

## 9. Examples & Edge Cases

### Light Palette Color Mapping

The following table maps VS Code 2026 Light colors to palette keys:

#### Backgrounds

| Palette Key | VS Code Light Color | VS Code Source |
|-------------|-------------------|----------------|
| `bg` | `#FFFFFF` | editor.background |
| `bg_alt` | `#FAFAFD` | sidebar.background, activityBar.background, panel.background |
| `bg_menu` | `#F4F4F5` | editorWidget.background (derived, slightly darker than bg_alt) |
| `bg_line` | `#F0F0F1` | lineHighlight (derived, subtle hover) |
| `bg_widget` | `#F0F0F1` | widget hover (derived) |
| `bg_select` | `#ADD6FF` | selection (derived, blue-tinted) |
| `bg_match` | `#E2E2E3` | findMatch background (derived) |
| `border` | `#D1D5DB` | border (derived) |
| `border_alt` | `#C4C8CC` | border alt (derived) |

#### Foregrounds

| Palette Key | VS Code Light Color | VS Code Source |
|-------------|-------------------|----------------|
| `fg` | `#202020` | editor.foreground |
| `fg_alt` | `#1E1E1E` | slightly darker variant |
| `fg_dim` | `#616161` | muted foreground |
| `fg_muted` | `#A0A0A0` | very muted foreground |
| `white` | `#FFFFFF` | pure white (used for high-contrast fg on colored bg) |

#### Accent

| Palette Key | VS Code Light Color | VS Code Source |
|-------------|-------------------|----------------|
| `accent` | `#0069CC` | focusBorder, info diagnostic |
| `accent_dim` | `#54A3F5` | lighter accent for bg |
| `accent_alt` | `#0550AE` | slightly different accent |

#### Syntax

| Palette Key | VS Code Light Color | VS Code Source |
|-------------|-------------------|----------------|
| `comment` | `#6E7781` | Comments |
| `string` | `#0A3069` | Strings/regex |
| `regex` | `#116329` | Tags/classes (green) |
| `number` | `#0550AE` | Constants/placeholders (blue) |
| `keyword` | `#CF222E` | Keywords/storage (red) |
| `func` | `#8250DF` | Functions (purple) |
| `type` | `#116329` | Tags/classes (green) |
| `variable` | `#202020` | default fg |
| `constant` | `#0550AE` | Constants/placeholders (blue) |
| `operator` | `#CF222E` | Keywords (red, for consistency) |
| `preproc` | `#CF222E` | Control flow (red) |
| `annotation` | `#953800` | Variables/exports (orange) |
| `param` | `#1F2328` | Parameters/members (near-black) |
| `member` | `#0550AE` | Support/property names (blue) |
| `tag` | `#116329` | Tags/classes (green) |
| `attr` | `#0550AE` | Attributes (blue) |
| `module` | `#116329` | Module/namespace (green) |
| `macro` | `#8250DF` | Functions (purple) |

#### Diagnostics

| Palette Key | VS Code Light Color | VS Code Source |
|-------------|-------------------|----------------|
| `err` | `#AD0707` | error diagnostic |
| `warn` | `#667309` | warning diagnostic |
| `info` | `#0069CC` | info diagnostic |
| `hint` | `#0550AE` | hint (derived from blue) |
| `ok` | `#587C0C` | ok diagnostic |
| `debug` | `#8250DF` | debug (purple) |

#### Diff

| Palette Key | VS Code Light Color | VS Code Source |
|-------------|-------------------|----------------|
| `diff_add` | `#DAFBE1` | added background |
| `diff_add_fg` | `#116329` | added foreground |
| `diff_del` | `#FFEBE9` | deleted background |
| `diff_del_fg` | `#82071E` | deleted foreground |
| `diff_chg` | `#FFD8B5` | changed background |
| `diff_chg_fg` | `#953800` | changed foreground |
| `diff_text` | `#FFF2CC` | changed text (derived, yellowish) |

### Edge Cases

#### User Override with Light Variant

```lua
require('dark-2026').setup({
  background = 'light',
  palette = {
    bg = '#F8F8F8',  -- Override the default #FFFFFF
  },
})
-- Result: bg = '#F8F8F8', all other light palette colors unchanged
```

#### Transparent Background in Light Mode

```lua
require('dark-2026').setup({
  background = 'light',
  transparent = true,
})
-- Result: bg_normal = 'NONE', bg_panel = 'NONE', etc.
```

#### Lualine in Light Mode

```lua
-- lualine config
require('lualine').setup({
  options = {
    theme = 'dark-2026',  -- Works for both variants
  },
})
-- Result: lualine picks up light palette via require('dark-2026').colors()
```

## 10. Validation Criteria

### Functional Validation

- [ ] `colors/dark-2026.lua` loads dark variant (no config needed)
- [ ] `colors/light-2026.lua` loads light variant (sets background='light')
- [ ] `setup({ background = 'light' })` uses light palette
- [ ] `setup({ background = 'dark' })` or no background uses dark palette
- [ ] `setup()` with no background option defaults to dark (backward compat)
- [ ] Terminal colors are set correctly for both variants
- [ ] Lualine theme works for both variants
- [ ] User palette overrides work for both variants

### Visual Validation

- [ ] Light variant has white editor background
- [ ] Light variant has near-black editor foreground
- [ ] Keywords are red (`#CF222E`)
- [ ] Functions are purple (`#8250DF`)
- [ ] Strings are dark blue (`#0A3069`)
- [ ] Comments are gray (`#6E7781`)
- [ ] Diff added has green background (`#DAFBE1`)
- [ ] Diff deleted has red background (`#FFEBE9`)
- [ ] Diagnostics use correct colors (error=red, warn=yellow-green, info=blue)

### Regression Validation

- [ ] Dark variant colors are unchanged
- [ ] Existing `dark-2026` entry point works
- [ ] `palette.base` alias still works
- [ ] All plugin highlight groups work for both variants

## 11. Related Specifications / Further Reading

- VS Code 2026 Light Theme: `2026-light.json` (source of truth for light colors)
- VS Code 2026 Dark Theme: `2026-dark.json` (source of truth for dark colors)
- Existing palette structure: `lua/dark-2026/palette.lua`
- Group modules: `lua/dark-2026/groups/*.lua`

---

## Implementation Steps (Ordered)

### Step 1: Update `config.lua` - Add `background` option

**File**: `lua/dark-2026/config.lua`

**Changes**:
1. Add `background = 'dark'` to `M.defaults` (after line 11, before `transparent`)
2. Add type annotation: `---@field background 'light'|'dark'`
3. Add validation in `M.extend()` to warn on invalid values

**Result**:
```lua
M.defaults = {
  --- Background mode: 'light' or 'dark'.
  ---@type 'light'|'dark'
  background = 'dark',
  --- Transparent editor background ...
  transparent = false,
  -- ... rest unchanged
}
```

### Step 2: Update `palette.lua` - Add light palette, rename base to dark

**File**: `lua/dark-2026/palette.lua`

**Changes**:
1. Rename `M.base` to `M.dark` (line 6)
2. Add `M.base = M.dark` alias (after M.dark definition)
3. Add `M.light` table with all light colors (after M.dark)
4. Update `M.get()` to select palette based on `opts.background`

**Result**:
```lua
local M = {}

--- Dark palette (VS Code Dark Modern 2026)
M.dark = {
  none = 'NONE',
  bg = '#121314',
  -- ... all existing dark colors (unchanged) ...
}

--- Backward-compatible alias
M.base = M.dark

--- Light palette (VS Code 2026 Light)
M.light = {
  none = 'NONE',
  
  -- Backgrounds (lightest -> darkest)
  bg = '#FFFFFF',
  bg_alt = '#FAFAFD',
  bg_menu = '#F4F4F5',
  bg_line = '#F0F0F1',
  bg_widget = '#F0F0F1',
  bg_select = '#ADD6FF',
  bg_match = '#E2E2E3',
  border = '#D1D5DB',
  border_alt = '#C4C8CC',
  
  -- Foregrounds
  fg = '#202020',
  fg_alt = '#1E1E1E',
  fg_dim = '#616161',
  fg_muted = '#A0A0A0',
  white = '#FFFFFF',
  
  -- Accent
  accent = '#0069CC',
  accent_dim = '#54A3F5',
  accent_alt = '#0550AE',
  
  -- Syntax
  comment = '#6E7781',
  string = '#0A3069',
  regex = '#116329',
  number = '#0550AE',
  keyword = '#CF222E',
  func = '#8250DF',
  type = '#116329',
  variable = '#202020',
  constant = '#0550AE',
  operator = '#CF222E',
  preproc = '#CF222E',
  annotation = '#953800',
  param = '#1F2328',
  member = '#0550AE',
  tag = '#116329',
  attr = '#0550AE',
  module = '#116329',
  macro = '#8250DF',
  
  -- Diagnostics
  err = '#AD0707',
  warn = '#667309',
  info = '#0069CC',
  hint = '#0550AE',
  ok = '#587C0C',
  debug = '#8250DF',
  
  -- Diff
  diff_add = '#DAFBE1',
  diff_add_fg = '#116329',
  diff_del = '#FFEBE9',
  diff_del_fg = '#82071E',
  diff_chg = '#FFD8B5',
  diff_chg_fg = '#953800',
  diff_text = '#FFF2CC',
}

--- Resolve palette for config
function M.get(opts)
  opts = opts or require('dark-2026.config').defaults
  
  -- Select base palette based on background mode
  local base = (opts.background == 'light') 
    and vim.deepcopy(M.light) 
    or vim.deepcopy(M.dark)
  
  local c = vim.tbl_extend('force', base, opts.palette or {})
  
  -- ... rest of M.get() unchanged (derives bg_normal, bg_panel, etc.) ...
end
```

### Step 3: Update `init.lua` - Set background from config, use colorscheme name

**File**: `lua/dark-2026/init.lua`

**Changes**:
1. Set `vim.o.background` from `options.background` (line 57)
2. Set `vim.g.colors_name` based on background mode (line 58)

**Result**:
```lua
function M.load(opts)
  local options = resolve(opts)
  
  if vim.g.colors_name then
    vim.cmd 'highlight clear'
  end
  if vim.fn.exists 'syntax_on' == 1 then
    vim.cmd 'syntax reset'
  end
  
  vim.o.termguicolors = true
  vim.o.background = options.background  -- Changed from hardcoded 'dark'
  vim.g.colors_name = (options.background == 'light') 
    and 'light-2026' 
    or 'dark-2026'  -- Changed from hardcoded 'dark-2026'
  
  -- ... rest unchanged ...
end
```

### Step 4: Create `colors/light-2026.lua` entry point

**File**: `colors/light-2026.lua` (NEW)

**Content**:
```lua
-- :colorscheme light-2026
require('dark-2026').setup({ background = 'light' })
require('dark-2026').load()
```

**Rationale**: The entry point must explicitly set `background='light'` before loading, because the user may have `setup()` called earlier with `background='dark'` or no background option.

### Step 5: Update `colors/dark-2026.lua` entry point (optional, for clarity)

**File**: `colors/dark-2026.lua`

**Current**:
```lua
-- :colorscheme dark-2026
require('dark-2026').load()
```

**Proposed** (optional, for explicitness):
```lua
-- :colorscheme dark-2026
require('dark-2026').setup({ background = 'dark' })
require('dark-2026').load()
```

**Note**: This is optional since `background='dark'` is the default. The current version works fine.

### Step 6: Verify lualine theme (no changes needed)

**File**: `lua/lualine/themes/dark-2026.lua`

**No changes needed**. The lualine theme uses `require('dark-2026').colors()`, which calls `palette.get()`, which selects the correct palette based on config. It works for both variants automatically.

### Step 7: Verify group files (no changes needed)

**Files**: `lua/dark-2026/groups/*.lua`

**No changes needed**. All group files reference palette keys (`c.bg`, `c.fg`, `c.keyword`, etc.), not hardcoded colors. The palette resolution happens in `palette.get()`, so groups automatically get the correct colors for whichever variant is active.

---

## File Change Summary

| File | Action | Description |
|------|--------|-------------|
| `lua/dark-2026/config.lua` | Modify | Add `background = 'dark'` option with type annotation |
| `lua/dark-2026/palette.lua` | Modify | Rename `M.base` → `M.dark`, add `M.base` alias, add `M.light` table, update `M.get()` |
| `lua/dark-2026/init.lua` | Modify | Set `vim.o.background` from config, set `vim.g.colors_name` based on variant |
| `colors/light-2026.lua` | Create | New entry point for light variant |
| `lua/lualine/themes/dark-2026.lua` | No change | Works automatically via palette resolution |
| `lua/dark-2026/groups/*.lua` | No change | Works automatically via palette keys |

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Light palette colors don't match VS Code exactly | Low | Use VS Code 2026 Light as source of truth, iterate on visual testing |
| Breaking change for existing users | Medium | Default `background='dark'`, preserve `M.base` alias |
| Lualine theme looks bad in light mode | Low | Test with light palette, adjust mode colors if needed |
| User overrides break light palette | Low | User overrides are applied after base palette, same as dark |

## Timeline Estimate

1. **Step 1** (config.lua): 5 minutes
2. **Step 2** (palette.lua): 30 minutes (most work - defining light colors)
3. **Step 3** (init.lua): 5 minutes
4. **Step 4** (light-2026.lua): 2 minutes
5. **Step 5** (dark-2026.lua): 2 minutes (optional)
6. **Step 6-7** (verification): 10 minutes
7. **Testing**: 30 minutes

**Total**: ~85 minutes
