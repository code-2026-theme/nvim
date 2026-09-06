local M = {}

M.none = 'NONE'

---@param hex string "#rrggbb"
---@return number, number, number
function M.hex_to_rgb(hex)
  hex = hex:gsub('#', '')
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---@param r number
---@param g number
---@param b number
---@return string
function M.rgb_to_hex(r, g, b)
  local function clamp(v)
    return math.min(255, math.max(0, math.floor(v + 0.5)))
  end
  return string.format('#%02x%02x%02x', clamp(r), clamp(g), clamp(b))
end

--- Blend `fg` over `bg` with `alpha` (0 = all bg, 1 = all fg).
---@param fg string
---@param bg string
---@param alpha number
---@return string
function M.blend(fg, bg, alpha)
  if type(fg) ~= 'string' or type(bg) ~= 'string' or fg:sub(1, 1) ~= '#' or bg:sub(1, 1) ~= '#' then
    return fg
  end
  local fr, fg_, fb = M.hex_to_rgb(fg)
  local br, bg_, bb = M.hex_to_rgb(bg)
  return M.rgb_to_hex(
    fr * alpha + br * (1 - alpha),
    fg_ * alpha + bg_ * (1 - alpha),
    fb * alpha + bb * (1 - alpha)
  )
end

---@param hex string
---@param amount number 0..1
---@param bg? string blend target, defaults to black
---@return string
function M.darken(hex, amount, bg)
  return M.blend(hex, bg or '#000000', 1 - amount)
end

---@param hex string
---@param amount number 0..1
---@param fg? string blend target, defaults to white
---@return string
function M.lighten(hex, amount, fg)
  return M.blend(hex, fg or '#ffffff', 1 - amount)
end

--- Merge a style table (`{ bold = true, italic = false }`) into a highlight spec.
---@param base table
---@param style? table
---@return table
function M.style(base, style)
  if type(style) ~= 'table' then
    return base
  end
  return vim.tbl_extend('force', base, style)
end

--- Merge highlight group tables into `dst`, per group.
--- A spec containing `link` replaces the target completely.
---@param dst table<string, table>
---@param src table<string, table>
---@return table<string, table>
function M.merge_highlights(dst, src)
  for group, spec in pairs(src or {}) do
    if type(spec) ~= 'table' then
      dst[group] = spec
    elseif spec.link then
      dst[group] = { link = spec.link }
    elseif dst[group] and not dst[group].link then
      dst[group] = vim.tbl_extend('force', dst[group], spec)
    else
      dst[group] = vim.deepcopy(spec)
    end
  end
  return dst
end

return M
