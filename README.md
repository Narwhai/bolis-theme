# Bolis

A gray color scheme with muted, tone-matched accents for **Neovim**,
**Ghostty**, and **Noctalia**, in light and dark variants. All variants are
derived from [`color-palette.json`](color-palette.json) (the "Bolis palette"),
which is the source of truth — edit the palette there and update
[`lua/bolis/palette.lua`](lua/bolis/palette.lua), the
[`ghostty/themes/`](ghostty/themes/) files, and
[`noctalia/Bolis.json`](noctalia/Bolis.json) to match (run the verifier below to
check they are in sync).

## Palette roles

| Role  | Use                                              |
| ----- | ------------------------------------------------ |
| bg    | main background                                  |
| bg2   | elevated panels, floats, cursor line             |
| ui    | borders, separators, selection background        |
| ui2   | secondary UI foreground, window borders          |
| ui3   | muted blue accent for selected/focused UI        |
| tx    | primary text                                     |
| tx2   | secondary text (statusline, line numbers)        |
| tx3   | tertiary text — comments, dimmed by design       |
| red   | reserved for errors and deletions                |
| orange / yellow / green / cyan / blue / purple / magenta | accents |

Syntax mapping: keywords → magenta, imports/preprocessor → purple,
functions → blue, types → yellow, constants/numbers → orange,
strings → green, builtins/references → cyan.

## Neovim

Requires Neovim ≥ 0.9 and `termguicolors` enabled.

```
:colorscheme bolis         " follows 'background'
:colorscheme bolis-light
:colorscheme bolis-dark
```

Install with [lazy.nvim](https://lazy.folke.io) (this repository is a valid
plugin):

```lua
{
  "YOUR_USER/gray-color-scheme",
  lazy = false,
  priority = 1000,
},
```

then `vim.cmd.colorscheme("bolis")` in your config. Optional highlight
overrides:

```lua
require("bolis").setup({
  overrides = {
    Normal = { bg = "NONE" }, -- transparent background
  },
})
```

Covers treesitter (current and legacy capture names), LSP semantic tokens,
diagnostics, diffs, and the following plugins: blink.cmp, nvim-cmp, telescope,
which-key, lazy, mason, nvim-notify, noice, gitsigns, indent-blankline,
neo-tree, nvim-tree, bufferline, trouble, treesitter-context, flash, leap,
dashboard, alpha, nvim-dap + dap-ui, mini.nvim, rainbow-delimiters,
vim-illuminate.

## Ghostty

Copy the theme files into Ghostty's themes directory:

```sh
mkdir -p ~/.config/ghostty/themes
cp ghostty/themes/* ~/.config/ghostty/themes/
```

Then pick one in `~/.config/ghostty/config`:

```
theme = Bolis Dark
# or follow the desktop light/dark preference:
theme = light:Bolis Light,dark:Bolis Dark
```

The ANSI palette 0–15, cursor, and selection colors are identical to the
scheme's terminal colors in Neovim, so `:terminal` inside Neovim matches
Ghostty. ANSI slots 3/11 (yellow) use orange/yellow and 5/13 (magenta) use
purple/magenta so all eight accents fit the 16-color palette.

## Noctalia

Copy or symlink the palette into Noctalia's custom palettes directory:

```sh
mkdir -p ~/.config/noctalia/palettes
ln -sf "$PWD/noctalia/Bolis.json" ~/.config/noctalia/palettes/Bolis.json
```

Then pick **Bolis** under Settings → Colors, or select it from the CLI:

```sh
noctalia msg color-scheme-set custom Bolis
```

The dark and light variants follow Noctalia's theme mode. Its terminal colors
match the Ghostty themes.

## Verify

Checks that `palette.lua`, the Ghostty themes, and the Noctalia palette still
match `color-palette.json`, and smoke-tests loading all variants:

```sh
nvim --headless --clean -l scripts/verify.lua
```

## Layout

```
color-palette.json         source of truth (Bolis palette, OKHSL)
colors/bolis*.lua           colorscheme entry points
lua/bolis/                  palette, highlights, loader
ghostty/themes/            Ghostty theme files
noctalia/Bolis.json         Noctalia custom palette
scripts/verify.lua         sync + smoke-test verifier
```
