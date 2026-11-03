-- Verify the generated color schemes against color-palette.json.
--
-- Run: nvim --headless --clean -l scripts/verify.lua
-- Exits 0 on success, 1 on any mismatch.

-- Repo root (this file lives in scripts/).
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(root)

local failures = {}

local function fail(msg)
  table.insert(failures, msg)
  print("FAIL " .. msg)
end

local function ok(msg)
  print("ok   " .. msg)
end

local function hex_to_rgb(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

local function expected_rgb(hex)
  local r, g, b = hex_to_rgb(hex)
  return r * 65536 + g * 256 + b
end

-- 1. lua/tone/palette.lua must match color-palette.json exactly.
local json_text = vim.fn.readfile(root .. "/color-palette.json")
local data = vim.json.decode(table.concat(json_text, "\n"))
local palette = dofile(root .. "/lua/tone/palette.lua")

local key_map = {
  ["bg"] = "bg",
  ["bg-2"] = "bg2",
  ["ui"] = "ui",
  ["ui-2"] = "ui2",
  ["ui-3"] = "ui3",
  ["tx"] = "tx",
  ["tx-2"] = "tx2",
  ["tx-3"] = "tx3",
  ["red"] = "red",
  ["orange"] = "orange",
  ["yellow"] = "yellow",
  ["green"] = "green",
  ["cyan"] = "cyan",
  ["blue"] = "blue",
  ["purple"] = "purple",
  ["magenta"] = "magenta",
}

for _, mode in ipairs({ "light", "dark" }) do
  for json_key, lua_key in pairs(key_map) do
    local expected = data.modes[mode][json_key].hex
    local actual = palette[mode][lua_key]
    if string.lower(actual) ~= string.lower(expected) then
      fail(("palette.lua %s.%s = %s, want %s"):format(mode, lua_key, actual, expected))
    end
  end
end
ok("lua/tone/palette.lua matches color-palette.json")

-- 2. Ghostty themes must match the ANSI mapping and base colors.
for _, mode in ipairs({ "light", "dark" }) do
  local theme = vim.fn.readfile(root .. "/ghostty/themes/Tone " .. mode:gsub("^%l", string.upper))
  local values = {}
  for _, line in ipairs(theme) do
    local key, value = line:match("^(%S+)%s*=%s*(#%x%x%x%x%x%x)$")
    local palette_key, palette_value = line:match("^palette%s*=%s*(%d+)=(#%x%x%x%x%x%x)$")
    if palette_key then
      values["palette" .. palette_key] = string.lower(palette_value)
    elseif key then
      values[key] = string.lower(value)
    end
  end

  local c = palette[mode]
  local expected_values = {
    background = c.bg,
    foreground = c.tx,
    ["cursor-color"] = c.tx,
    ["cursor-text"] = c.bg,
    ["selection-background"] = c.ui,
    ["selection-foreground"] = c.tx,
  }
  for i = 1, 16 do
    expected_values["palette" .. (i - 1)] = string.lower(palette.ansi[mode][i])
  end

  for key, expected in pairs(expected_values) do
    if values[key] ~= expected then
      fail(("ghostty %s: %s = %s, want %s"):format(mode, key, tostring(values[key]), expected))
    end
  end
end
ok("ghostty themes match the palette and ANSI mapping")

-- 3. Noctalia palette must match the same roles and ANSI mapping.
local noctalia_text = vim.fn.readfile(root .. "/noctalia/Tone.json")
local noctalia = vim.json.decode(table.concat(noctalia_text, "\n"))

for _, mode in ipairs({ "light", "dark" }) do
  local c = palette[mode]
  local theme = noctalia[mode] or {}
  local terminal = theme.terminal or {}
  local normal = terminal.normal or {}
  local bright = terminal.bright or {}

  local expected = {
    mPrimary = c.blue,
    mOnPrimary = c.bg,
    mSecondary = c.purple,
    mOnSecondary = c.bg,
    mTertiary = c.cyan,
    mOnTertiary = c.bg,
    mError = c.red,
    mOnError = c.bg,
    mSurface = c.bg,
    mOnSurface = c.tx,
    mSurfaceVariant = c.bg2,
    mOnSurfaceVariant = c.tx2,
    mOutline = c.ui,
    mShadow = mode == "dark" and c.bg or c.ui,
    mHover = c.ui3,
    mOnHover = c.tx,
  }
  for key, want in pairs(expected) do
    local got = theme[key]
    if got == nil or string.lower(got) ~= string.lower(want) then
      fail(("noctalia %s: %s = %s, want %s"):format(mode, key, tostring(got), want))
    end
  end

  local ansi_keys = { "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" }
  for i, key in ipairs(ansi_keys) do
    local got_normal = normal[key]
    local got_bright = bright[key]
    if got_normal == nil or string.lower(got_normal) ~= string.lower(palette.ansi[mode][i]) then
      fail(
        ("noctalia %s: terminal.normal.%s = %s, want %s"):format(
          mode,
          key,
          tostring(got_normal),
          palette.ansi[mode][i]
        )
      )
    end
    if got_bright == nil or string.lower(got_bright) ~= string.lower(palette.ansi[mode][i + 8]) then
      fail(
        ("noctalia %s: terminal.bright.%s = %s, want %s"):format(
          mode,
          key,
          tostring(got_bright),
          palette.ansi[mode][i + 8]
        )
      )
    end
  end

  local terminal_expected = {
    foreground = c.tx,
    background = c.bg,
    selectionFg = c.tx,
    selectionBg = c.ui,
    cursor = c.tx,
    cursorText = c.bg,
  }
  for key, want in pairs(terminal_expected) do
    local got = terminal[key]
    if got == nil or string.lower(got) ~= string.lower(want) then
      fail(("noctalia %s: terminal.%s = %s, want %s"):format(mode, key, tostring(got), want))
    end
  end
end
ok("noctalia palette matches the palette and ANSI mapping")

-- 4. All three colorscheme entry points load without errors.
for _, scheme in ipairs({ "tone-dark", "tone-light", "tone" }) do
  local entry = root .. "/colors/" .. scheme .. ".lua"
  local chunk, err = loadfile(entry)
  if chunk == nil then
    fail(("cannot load %s: %s"):format(entry, tostring(err)))
  else
    local ok_call, err_call = pcall(chunk)
    if not ok_call then
      fail(("error loading colorscheme %s: %s"):format(scheme, tostring(err_call)))
    end
  end
end
ok("colors/tone.lua, tone-light.lua, tone-dark.lua load without errors")

-- 5. Sample highlight groups are applied with the right colors.
local tone = require("tone")

tone.load("dark")
local checks = {
  { group = "Normal", key = "fg", hex = palette.dark.tx },
  { group = "Normal", key = "bg", hex = palette.dark.bg },
  { group = "@keyword.conditional", key = "fg", hex = palette.dark.magenta },
  { group = "@function", key = "fg", hex = palette.dark.blue },
  { group = "Comment", key = "fg", hex = palette.dark.tx3 },
  { group = "DiffAdd", key = "bg", hex = nil }, -- blended tint, just check presence
  { group = "DiagnosticVirtualTextError", key = "bg", hex = nil },
  { group = "PmenuSel", key = "bg", hex = palette.dark.ui3 },
}
for _, check in ipairs(checks) do
  -- link = false resolves links so we see the final colors
  local hl = vim.api.nvim_get_hl(0, { name = check.group, link = false })
  if check.hex == nil then
    if hl[check.key] == nil then
      fail(("dark %s.%s is not set"):format(check.group, check.key))
    end
  elseif hl[check.key] ~= expected_rgb(check.hex) then
    fail(("dark %s.%s = %s, want %s"):format(check.group, check.key, tostring(hl[check.key]), check.hex))
  end
end
if vim.g.terminal_color_0 ~= palette.ansi.dark[1] then
  fail("dark terminal_color_0 does not match the Ghostty black")
end
ok("dark variant highlights are applied")

tone.load("light")
local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
if normal.bg ~= expected_rgb(palette.light.bg) or normal.fg ~= expected_rgb(palette.light.tx) then
  fail("light Normal is not tx on bg")
end
if vim.g.terminal_color_0 ~= palette.ansi.light[1] then
  fail("light terminal_color_0 does not match the Ghostty black")
end
if vim.o.background ~= "light" then
  fail("light variant did not set 'background'")
end
ok("light variant highlights are applied")

if #failures > 0 then
  print(("\n%d check(s) failed"):format(#failures))
  vim.cmd("cquit 1")
end

print("\nall checks passed")
vim.cmd("qa!")
