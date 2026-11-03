-- Bolis color scheme for Neovim (>= 0.9).
--
-- Variants "light" and "dark", generated from the "Bolis palette"
-- (color-palette.json in the repository root).
--
-- Usage:
--   :colorscheme bolis        follows 'background'
--   :colorscheme bolis-light
--   :colorscheme bolis-dark
--
-- Optional highlight overrides, applied after the scheme is loaded:
--   require("bolis").setup({
--     overrides = {
--       Normal = { bg = "NONE" },
--       Comment = { fg = "#6b6f74" },
--     },
--   })
local M = {}

local palette = require("bolis.palette")
local highlights = require("bolis.highlights")

M.palette = palette

local overrides = {}

local function parse_hex(hex)
  if type(hex) ~= "string" or not hex:match("^#%x%x%x%x%x%x$") then
    error("bolis: invalid hex color: " .. tostring(hex))
  end
  local r = tonumber(hex:sub(2, 3), 16)
  local g = tonumber(hex:sub(4, 5), 16)
  local b = tonumber(hex:sub(6, 7), 16)
  return r, g, b
end

--- Mix `fg` into `bg` with weight `alpha` (0 = bg, 1 = fg).
---@param fg string hex color
---@param bg string hex color
---@param alpha number
---@return string hex color
local function blend(fg, bg, alpha)
  local r1, g1, b1 = parse_hex(fg)
  local r2, g2, b2 = parse_hex(bg)
  local r = math.floor(r2 + (r1 - r2) * alpha + 0.5)
  local g = math.floor(g2 + (g1 - g2) * alpha + 0.5)
  local b = math.floor(b2 + (b1 - b2) * alpha + 0.5)
  return string.format("#%02x%02x%02x", r, g, b)
end

---@param name string
---@param spec table|string
local function apply(name, spec)
  if type(spec) == "string" then
    vim.api.nvim_set_hl(0, name, { link = spec })
  else
    vim.api.nvim_set_hl(0, name, spec)
  end
end

--- Configure the color scheme. Currently only `overrides` is supported.
---@param opts table? { overrides = table<string, table|string> }
function M.setup(opts)
  if opts ~= nil and type(opts) ~= "table" then
    error("bolis: setup() expects a table, got " .. type(opts))
  end
  opts = opts or {}
  if opts.overrides ~= nil and type(opts.overrides) ~= "table" then
    error("bolis: overrides must be a table, got " .. type(opts.overrides))
  end
  overrides = opts.overrides or {}
end

--- Load the color scheme.
---@param variant string? "light" or "dark"; defaults to the 'background' value
function M.load(variant)
  if variant == nil then
    variant = vim.o.background == "light" and "light" or "dark"
  end
  if variant ~= "light" and variant ~= "dark" then
    error('bolis: unknown variant (expected "light" or "dark"): ' .. tostring(variant))
  end

  if vim.o.background ~= variant then
    vim.o.background = variant
  end

  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  local c = palette[variant]
  for i = 1, 16 do
    vim.g["terminal_color_" .. (i - 1)] = palette.ansi[variant][i]
  end

  local groups = highlights.get(
    c,
    function(fg, bg, alpha)
      return blend(fg, bg, alpha)
    end
  )
  for name, spec in pairs(groups) do
    apply(name, spec)
  end
  for name, spec in pairs(overrides) do
    apply(name, spec)
  end

  vim.g.colors_name = "bolis"
end

return M
