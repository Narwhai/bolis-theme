-- Render assets/palette.svg from color-palette.json.
--
-- 8 swatches per row: base roles on top, accents below, for both modes.
-- Run: nvim --headless --clean -l scripts/render-palette.lua
-- Optional PNG (needs rsvg-convert):
--   rsvg-convert -z 2 -o assets/palette.png assets/palette.svg

-- Repo root (this file lives in scripts/).
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local data = vim.json.decode(table.concat(vim.fn.readfile(root .. "/color-palette.json"), "\n"))

local rows = {
  {
    { label = "bg", key = "bg" },
    { label = "bg2", key = "bg-2" },
    { label = "ui", key = "ui" },
    { label = "ui2", key = "ui-2" },
    { label = "ui3", key = "ui-3" },
    { label = "tx", key = "tx" },
    { label = "tx2", key = "tx-2" },
    { label = "tx3", key = "tx-3" },
  },
  {
    { label = "red", key = "red" },
    { label = "orange", key = "orange" },
    { label = "yellow", key = "yellow" },
    { label = "green", key = "green" },
    { label = "cyan", key = "cyan" },
    { label = "blue", key = "blue" },
    { label = "purple", key = "purple" },
    { label = "magenta", key = "magenta" },
  },
}

local modes = {
  { label = "Bolis Light", key = "light" },
  { label = "Bolis Dark", key = "dark" },
}

local margin = 32
local pad = 20
local col_w = 112
local gutter = 8
local swatch_h = 64
local label_h = 38
local row_gap = 18
local title_h = 30
local panel_gap = 24

local cols = #rows[1]
local panel_w = pad * 2 + cols * col_w + (cols - 1) * gutter
local panel_h = title_h + pad + #rows * (swatch_h + label_h) + (#rows - 1) * row_gap
local width = margin * 2 + panel_w
local height = margin * 2 + #modes * panel_h + (#modes - 1) * panel_gap

local out = {}
local function add(fmt, ...)
  table.insert(out, select("#", ...) > 0 and fmt:format(...) or fmt)
end

local function escape(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

add('<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" viewBox="0 0 %d %d">', width, height, width, height)
add('<style>')
add('  text { font-family: ui-monospace, "SF Mono", Menlo, Consolas, monospace; }')
add('  .title { font-size: 15px; font-weight: 600; }')
add('  .role { font-size: 12px; }')
add('  .hex { font-size: 11px; }')
add('</style>')

for m, mode in ipairs(modes) do
  local palette = data.modes[mode.key]
  local bg = palette["bg"].hex
  local tx = palette["tx"].hex
  local tx3 = palette["tx-3"].hex
  local ui = palette["ui"].hex
  local x0 = margin
  local y0 = margin + (m - 1) * (panel_h + panel_gap)

  add('<rect x="%d" y="%d" width="%d" height="%d" rx="8" fill="%s" stroke="%s" stroke-width="1"/>',
    x0, y0, panel_w, panel_h, bg, ui)
  add('<text class="title" x="%d" y="%d" fill="%s">%s</text>',
    x0 + pad, y0 + pad + 11, tx, escape(mode.label))

  for r, row in ipairs(rows) do
    local top = y0 + title_h + pad + (r - 1) * (swatch_h + label_h + row_gap)
    for c, entry in ipairs(row) do
      local left = x0 + pad + (c - 1) * (col_w + gutter)
      local hex = palette[entry.key].hex
      add('<rect x="%d" y="%d" width="%d" height="%d" rx="5" fill="%s" stroke="%s" stroke-width="1"/>',
        left, top, col_w, swatch_h, hex, ui)
      add('<text class="role" x="%d" y="%d" fill="%s">%s</text>',
        left + 2, top + swatch_h + 16, tx, escape(entry.label))
      add('<text class="hex" x="%d" y="%d" fill="%s">%s</text>',
        left + 2, top + swatch_h + 32, tx3, escape(hex))
    end
  end
end

add('</svg>')

local path = root .. "/assets/palette.svg"
vim.fn.mkdir(root .. "/assets", "p")
local ok = vim.fn.writefile(out, path)
if ok ~= 0 then
  error("failed to write " .. path)
end
print("wrote " .. path .. (" (%dx%d)"):format(width, height))
