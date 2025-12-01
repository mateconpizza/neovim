---@class me.core.colors.Base
---@field dark0_hard string
---@field dark0 string
---@field dark0_soft string
---@field dark1 string
---@field dark2 string
---@field dark3 string
---@field dark4 string
---@field light0_hard string
---@field light0 string
---@field light0_soft string
---@field light1 string
---@field light2 string
---@field light3 string
---@field light4 string

---@class me.core.colors.ColorSet
---@field black   string
---@field red     string
---@field green   string
---@field yellow  string
---@field blue    string
---@field magenta string
---@field cyan    string
---@field white   string

---@class me.core.colors.Extra
---@field orange string
---@field aqua   string
---@field purple string
---@field gray   string

---@class me.core.colors.Diff
---@field add string
---@field delete string
---@field change string
---@field text string

---@class me.core.colors.Palette
---@field name string               Name of the palette (e.g. "gruvbox")
---@field variant string            Variant name (e.g. "dark" or "light")
---@field bg string
---@field fg string
---@field none string
---@field border string
---@field base me.core.colors.Base
---@field normal me.core.colors.ColorSet
---@field bright me.core.colors.ColorSet
---@field extras me.core.colors.Extra

---@class me.core.colors
local M = {}

---@class Tokyonight
---@field storm me.core.colors.Palette
---@field night me.core.colors.Palette
---@field day me.core.colors.Palette

---@class Colorscheme
---@field dark me.core.colors.Palette
---@field light me.core.colors.Palette

---@class me.core.colors.Palletes
---@field tokyonight Tokyonight
---@field gruvbox Colorscheme
---@field gruvbox_material Colorscheme
---@field catppuccin Colorscheme
M.palettes = {
  tokyonight = {
    storm = {
      name = 'tokyonight',
      variant = 'storm',

      bg = '#24283b',
      fg = '#a9b1d6',
      none = 'NONE',
      border = '#1a1b26',

      base = {
        dark0_hard = '#1a1b26',
        dark0 = '#24283b',
        dark0_soft = '#2f334d',
        dark1 = '#3b4261',
        dark2 = '#414868',
        dark3 = '#545c7e',
        dark4 = '#565f89',

        light0_hard = '#c0caf5',
        light0 = '#a9b1d6',
        light0_soft = '#9aa5ce',
        light1 = '#7aa2f7',
        light2 = '#9d7cd8',
        light3 = '#bb9af7',
        light4 = '#c0caf5',
      },

      normal = {
        black = '#1a1b26',
        red = '#f7768e',
        green = '#9ece6a',
        yellow = '#e0af68',
        blue = '#7aa2f7',
        magenta = '#bb9af7',
        cyan = '#4abaaf',
        white = '#c0caf5',
      },

      bright = {
        black = '#414868',
        red = '#ff7a93',
        green = '#b9f27c',
        yellow = '#ffcb6b',
        blue = '#7dcfff',
        magenta = '#c099ff',
        cyan = '#41a6b5',
        white = '#c0caf5',
      },

      extras = {
        orange = '#ff9e64',
        aqua = '#4abaaf',
        purple = '#bb9af7',
        gray = '#565f89',
      },
    },
    night = {
      name = 'tokyonight',
      variant = 'night',

      bg = '#1a1b26',
      fg = '#c0caf5',
      none = 'NONE',
      border = '#15161e',

      base = {
        dark0_hard = '#15161e',
        dark0 = '#1a1b26',
        dark0_soft = '#1e2030',
        dark1 = '#24283b',
        dark2 = '#292e42',
        dark3 = '#414868',
        dark4 = '#565f89',

        light0_hard = '#c0caf5',
        light0 = '#a9b1d6',
        light0_soft = '#9aa5ce',
        light1 = '#7aa2f7',
        light2 = '#9d7cd8',
        light3 = '#bb9af7',
        light4 = '#c0caf5',
      },

      normal = {
        black = '#15161e',
        red = '#f7768e',
        green = '#9ece6a',
        yellow = '#e0af68',
        blue = '#7aa2f7',
        magenta = '#bb9af7',
        cyan = '#7dcfff',
        white = '#c0caf5',
      },

      bright = {
        black = '#414868',
        red = '#ff7a93',
        green = '#b9f27c',
        yellow = '#ffcb6b',
        blue = '#7dcfff',
        magenta = '#c099ff',
        cyan = '#7dcfff',
        white = '#c0caf5',
      },

      extras = {
        orange = '#ff9e64',
        aqua = '#7dcfff',
        purple = '#bb9af7',
        gray = '#565f89',
      },
    },
    day = {
      name = 'tokyonight',
      variant = 'day',

      bg = '#e1e2e7',
      fg = '#3760bf',
      none = 'NONE',
      border = '#b4b5b9',

      base = {
        dark0_hard = '#c4c8d8',
        dark0 = '#e1e2e7',
        dark0_soft = '#e9e9ed',
        dark1 = '#c4c8d8',
        dark2 = '#b4b5b9',
        dark3 = '#a1a6c5',
        dark4 = '#8a8fb3',

        light0_hard = '#6172b0',
        light0 = '#545c7e',
        light0_soft = '#4a4f61',
        light1 = '#3760bf',
        light2 = '#2e7de9',
        light3 = '#9854f1',
        light4 = '#6172b0',
      },

      normal = {
        black = '#b4b5b9',
        red = '#f52a65',
        green = '#587539',
        yellow = '#8c6c3e',
        blue = '#2e7de9',
        magenta = '#9d7cd8',
        cyan = '#007197',
        white = '#6172b0',
      },

      bright = {
        black = '#7c8194',
        red = '#c64374',
        green = '#729558',
        yellow = '#b18946',
        blue = '#4fa4ff',
        magenta = '#b48df3',
        cyan = '#1d8ca4',
        white = '#6172b0',
      },

      extras = {
        orange = '#ff9e64',
        aqua = '#007197',
        purple = '#9d7cd8',
        gray = '#a1a6c5',
      },
    },
  },
  gruvbox = {
    dark = {
      name = 'gruvbox',
      variant = 'dark',

      bg = '#282828',
      fg = '#ebdbb2',
      none = 'NONE',
      border = '#282828',

      base = {
        dark0_hard = '#1d2021',
        dark0 = '#282828',
        dark0_soft = '#32302f',
        dark1 = '#3c3836',
        dark2 = '#504945',
        dark3 = '#665c54',
        dark4 = '#7c6f64',

        light0_hard = '#f9f5d7',
        light0 = '#fbf1c7',
        light0_soft = '#f2e5bc',
        light1 = '#ebdbb2',
        light2 = '#d5c4a1',
        light3 = '#bdae93',
        light4 = '#a89984',
      },

      normal = {
        black = '#282828',
        red = '#cc241d',
        green = '#98971a',
        yellow = '#d79921',
        blue = '#458588',
        magenta = '#b16286',
        cyan = '#689d6a',
        white = '#a89984',
      },

      bright = {
        black = '#928374',
        red = '#fb4934',
        green = '#b8bb26',
        yellow = '#fabd2f',
        blue = '#83a598',
        magenta = '#d3869b',
        cyan = '#8ec07c',
        white = '#ebdbb2',
      },

      extras = {
        orange = '#d65d0e',
        aqua = '#689d6a',
        purple = '#b16286',
        gray = '#928374',
      },
    },
    light = {
      name = 'gruvbox',
      variant = 'light',

      bg = '#fbf1c7',
      fg = '#3c3836',
      none = 'NONE',
      border = '#fbf1c7',

      base = {
        dark0_hard = '#f9f5d7',
        dark0 = '#fbf1c7',
        dark0_soft = '#f2e5bc',
        dark1 = '#ebdbb2',
        dark2 = '#d5c4a1',
        dark3 = '#bdae93',
        dark4 = '#a89984',

        light0_hard = '#1d2021',
        light0 = '#282828',
        light0_soft = '#32302f',
        light1 = '#3c3836',
        light2 = '#504945',
        light3 = '#665c54',
        light4 = '#7c6f64',
      },

      normal = {
        black = '#fbf1c7',
        red = '#9d0006',
        green = '#79740e',
        yellow = '#b57614',
        blue = '#076678',
        magenta = '#8f3f71',
        cyan = '#427b58',
        white = '#3c3836',
      },

      bright = {
        black = '#928374',
        red = '#cc241d',
        green = '#98971a',
        yellow = '#d79921',
        blue = '#458588',
        magenta = '#b16286',
        cyan = '#689d6a',
        white = '#7c6f64',
      },

      extras = {
        orange = '#af3a03',
        aqua = '#427b58',
        purple = '#b16286',
        gray = '#928374',
      },
    },
  },
  gruvbox_material = {
    dark = {
      name = 'gruvbox-material',
      variant = 'dark',

      bg = '#1d2021',
      fg = '#d4be98',
      none = 'NONE',
      border = '#1d2021',

      base = {
        dark0_hard = '#1d2021',
        dark0 = '#282828',
        dark0_soft = '#32302f',
        dark1 = '#3c3836',
        dark2 = '#504945',
        dark3 = '#665c54',
        dark4 = '#7c6f64',

        light0_hard = '#f9f5d7',
        light0 = '#ebdbb2',
        light0_soft = '#d5c4a1',
        light1 = '#bdae93',
        light2 = '#a89984',
        light3 = '#928374',
        light4 = '#7c6f64',
      },

      normal = {
        black = '#32302f',
        red = '#ea6962',
        green = '#a9b665',
        yellow = '#e78a4e',
        blue = '#7daea3',
        magenta = '#d3869b',
        cyan = '#89b482',
        white = '#d4be98',
      },

      bright = {
        black = '#3c3836',
        red = '#f2594b',
        green = '#b0c36a',
        yellow = '#ff9e64',
        blue = '#8ec07c',
        magenta = '#e4a0c4',
        cyan = '#9dc9a5',
        white = '#f2e5bc',
      },

      extras = {
        orange = '#e78a4e',
        aqua = '#689d6a',
        purple = '#d3869b',
        gray = '#a89984',
      },
    },
    light = {
      name = 'gruvbox-material',
      variant = 'light',

      bg = '#f9f5d7',
      fg = '#654735',
      none = 'NONE',
      border = '#f9f5d7',

      base = {
        dark0_hard = '#f2e5bc',
        dark0 = '#ebdbb2',
        dark0_soft = '#d5c4a1',
        dark1 = '#bdae93',
        dark2 = '#a89984',
        dark3 = '#928374',
        dark4 = '#7c6f64',

        light0_hard = '#1d2021',
        light0 = '#282828',
        light0_soft = '#32302f',
        light1 = '#3c3836',
        light2 = '#504945',
        light3 = '#665c54',
        light4 = '#7c6f64',
      },

      normal = {
        black = '#32302f',
        red = '#c14a4a',
        green = '#6c782e',
        yellow = '#c35e0a',
        blue = '#45707a',
        magenta = '#945e80',
        cyan = '#4c7a5d',
        white = '#654735',
      },

      bright = {
        black = '#504945',
        red = '#ea6962',
        green = '#a9b665',
        yellow = '#e78a4e',
        blue = '#7daea3',
        magenta = '#d3869b',
        cyan = '#89b482',
        white = '#f9f5d7',
      },

      extras = {
        orange = '#c35e0a',
        purple = '#945e80',
        aqua = '#427b58',
        gray = '#32302f',
      },
    },
  },
  catppuccin = {
    dark = {
      name = 'catppuccin',
      variant = 'macchiato',

      bg = '#24273A',
      fg = '#CAD3F5',
      none = 'NONE',
      border = '#24273A',

      base = {
        dark0_hard = '#1e2030',
        dark0 = '#1e2030',
        dark0_soft = '#24273A',
        dark1 = '#24273A',
        dark2 = '#494D64',
        dark3 = '#5B6078',
        dark4 = '#5B6078',

        light0_hard = '#EFF1F5',
        light0 = '#CAD3F5',
        light0_soft = '#CAD3F5',
        light1 = '#B8C0E0',
        light2 = '#A5ADCB',
        light3 = '#939AB7',
        light4 = '#939AB7',
      },

      normal = {
        black = '#494D64',
        red = '#ED8796',
        green = '#A6DA95',
        yellow = '#EED49F',
        blue = '#8AADF4',
        magenta = '#F5BDE6',
        cyan = '#8BD5CA',
        white = '#B8C0E0',
      },

      bright = {
        black = '#5B6078',
        red = '#F28FAD',
        green = '#BEE4A3',
        yellow = '#F5E0BB',
        blue = '#A5C5F9',
        magenta = '#F7C7ED',
        cyan = '#A8EDE3',
        white = '#EFF1F5',
      },

      extras = {
        purple = '#F5BDE6',
        orange = '#F5A97F',
        lightgrey = '#A5ADCB',
        darkgrey = '#A5ADCB',
      },
    },
    light = {
      name = 'catppuccin',
      variant = 'latte',

      bg = '#EFF1F5',
      fg = '#4C4F69',
      none = 'NONE',
      border = '#EFF1F5',

      base = {
        dark0_hard = '#4C4F69',
        dark0 = '#4C4F69',
        dark0_soft = '#5C5F77',
        dark1 = '#5C5F77',
        dark2 = '#6C6F85',
        dark3 = '#7C7F93',
        dark4 = '#7C7F93',

        light0_hard = '#EFF1F5',
        light0 = '#EFF1F5',
        light0_soft = '#DCE0E8',
        light1 = '#DCE0E8',
        light2 = '#BCC0CC',
        light3 = '#ACB0BE',
        light4 = '#ACB0BE',
      },

      normal = {
        black = '#5C5F77',
        red = '#D20F39',
        green = '#40A02B',
        yellow = '#DF8E1D',
        blue = '#1E66F5',
        magenta = '#EA76CB',
        cyan = '#179299',
        white = '#ACB0BE',
      },

      bright = {
        black = '#6C6F85',
        red = '#E64553',
        green = '#5AA05A',
        yellow = '#E5A95C',
        blue = '#5690F5',
        magenta = '#EE9AD6',
        cyan = '#4AA5A9',
        white = '#EFF1F5',
      },

      extras = {
        purple = '#EA76CB',
        lightgrey = '#A5ADCB',
        darkgrey = '#A5ADCB',
      },
    },
  },
}

---@return me.core.colors.Palette
function M.tokyonight_storm()
  return M.palettes.tokyonight.storm
end

---@return me.core.colors.Palette
function M.tokyonight_night()
  return M.palettes.tokyonight.night
end

---@return me.core.colors.Palette
function M.tokyonight_day()
  return M.palettes.tokyonight.day
end

---@return me.core.colors.Palette
function M.gruvbox_material_dark()
  return M.palettes.gruvbox_material.dark
end

---@return me.core.colors.Palette
function M.gruvbox_material_light()
  return M.palettes.gruvbox_material.light
end

---@return me.core.colors.Palette
function M.catppuccin_macchiato()
  return M.palettes.catppuccin.macchiato
end

---@return me.core.colors.Palette
function M.catppuccin_latte()
  return M.palettes.catppuccin.latte
end

---@return me.core.colors.Palette
function M.gruvbox_dark_medium()
  return M.palettes.gruvbox.dark
end

---@return me.core.colors.Palette
function M.gruvbox_light_medium()
  return M.palettes.gruvbox.light
end

---@param hex_str string hexadecimal value of a color
local function hex_to_rgb(hex_str)
  local hex = '[abcdef0-9][abcdef0-9]'
  local pat = '^#(' .. hex .. ')(' .. hex .. ')(' .. hex .. ')$'
  hex_str = string.lower(hex_str)

  assert(string.find(hex_str, pat) ~= nil, 'hex_to_rgb: invalid hex_str: ' .. tostring(hex_str))

  local red, green, blue = string.match(hex_str, pat)
  return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
end

---@param fg string forecrust color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(fg, bg, alpha)
  ---@diagnostic disable-next-line: cast-local-type
  bg = hex_to_rgb(bg)
  ---@diagnostic disable-next-line: cast-local-type
  fg = hex_to_rgb(fg)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format('#%02X%02X%02X', blendChannel(1), blendChannel(2), blendChannel(3))
end

function M.darken(hex, amount, bg)
  local default_bg = '#000000'
  return M.blend(hex, bg or default_bg, math.abs(amount))
end

function M.lighten(hex, amount, fg)
  local default_fg = '#ffffff'
  return M.blend(hex, fg or default_fg, math.abs(amount))
end

---@return boolean
function M.is_darkmode()
  return vim.o.background == 'dark'
end

---@return me.core.colors.Palette
function M.get_colors()
  return M.gruvbox_dark_medium() and M.gruvbox_dark_medium() or M.gruvbox_light_medium()
end

function M.current()
  return M.gruvbox_dark_medium()
end

return M
