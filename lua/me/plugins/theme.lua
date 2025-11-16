return {

  { -- https://github.com/catppuccin/nvim
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    enabled = Core.env.get('NVIM_THEME', '') == 'catppuccin',
    opts = function()
      return {
        flavour = 'mocha',
        transparent_background = false,
        show_end_of_buffer = true,
        styles = {
          comments = { 'italic' },
          conditionals = { 'italic' },
          loops = { 'italic' },
          functions = {},
          keywords = {},
          strings = { 'italic' },
          variables = {},
          numbers = {},
          booleans = { 'italic' },
          properties = {},
          types = {},
          operators = {},
        },
        default_integrations = false,
        integrations = {
          blink_cmp = true,
          cmp = false,
          gitsigns = true,
          nvimtree = false,
          treesitter = true,
          treesitter_context = true,
          neotest = true,
          lsp_trouble = true,
          which_key = false,
          aerial = true,
          fidget = true,
          leap = true,
          mason = true,
          dap = true,
          dap_ui = true,
          fzf = true,
          indent_blankline = { enabled = true, colored_indent_levels = true },
          mini = { enabled = true, indentscope_color = '' },
        },
      }
    end,
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },

  { -- https://github.com/sainnhe/gruvbox-material
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    enabled = Core.env.get('NVIM_THEME', '') == 'gruvbox',
    config = function()
      vim.g.gruvbox_material_enable_bold = true
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_transparent_background = true
      vim.g.gruvbox_material_dim_inactive_windows = false
      vim.g.gruvbox_material_disable_italic_comment = false
      vim.g.gruvbox_material_diagnostic_text_highlight = true
      vim.g.gruvbox_material_background = 'hard' -- hard, medium, soft
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored' -- grey, colored, highlighted
      vim.g.gruvbox_material_spell_foreground = 'colored' -- none
      vim.g.gruvbox_material_ui_contrast = 'high' -- 'low'
      vim.g.gruvbox_material_show_eob = true
      vim.g.gruvbox_material_current_word = 'underline'
      -- vim.g.gruvbox_material_menu_selection_background = 'red'
      vim.g.gruvbox_material_float_style = 'storm' -- 'storm', 'dim'
      vim.g.gruvbox_material_foreground = 'material' -- 'material' 'original' 'mix'
      vim.g.gruvbox_material_diagnostic_line_highlight = true
      vim.g.gruvbox_material_visual = 'grey background' -- 'reverse'
      vim.g.gruvbox_material_inlay_hints_background = 'none' -- 'dimmed'
      vim.g.gruvbox_material_better_performance = true
      vim.cmd('colorscheme gruvbox-material')

      local c = Core.colors.get_colors()
      Core.hi.CurrentWord = { bg = c.base.dark0_soft, bold = true, italic = true }
      Core.hi.Folded = { bg = c.base.dark0_soft, fg = c.bright.blue, italic = true }
      Core.hi.LineNr = { fg = c.base.dark3 }
      Core.hi.MatchParen = { bg = c.base.dark2, fg = c.extras.orange, bold = true }
      Core.hi.TSDanger = { fg = c.normal.red, bold = true }
      Core.hi.TSNote = { fg = c.normal.green, bold = true }
      Core.hi.TSWarning = { fg = c.normal.yellow, bold = true }
      Core.hi.Todo = { fg = c.normal.blue, bold = true }
      Core.hi['@constant'] = { fg = c.normal.magenta }
    end,
  },

  { -- https://github.com/folke/tokyonight.nvim
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    enabled = Core.env.get('NVIM_THEME', '') == 'tokyonight',
    opts = function()
      return {
        style = 'day',
        sidebars = {
          'qf',
          'vista_kind',
          'vista',
          'terminal',
          'toggleterm',
          'spectre_panel',
          'neogitstatus',
          'help',
          'startuptime',
          'outline',
        },
        transparent = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = { bold = false },
          variables = {},
          sidebars = 'normal', -- "dark", "transparent" or "normal"
          floats = 'normal', -- "dark", "transparent" or "normal"
        },
      }
    end,
    config = function(_, opts)
      local tokyonight = require('tokyonight')
      tokyonight.setup(opts)
      tokyonight.load()
    end,
  },

  { -- https://github.com/mateconpizza/retrobox.nvim
    'mateconpizza/retrobox.nvim',
    enabled = true,
    opts = {
      styles = {
        Function = { bold = false },
        Keyword = { italic = true },
        VertSplit = { bg = 'NONE', bold = true },
      },
      integrations = {
        lsp = true,
        neotest = true,
        treesitter = true,
        treesitter_context = false,
        fzf = false,
        gitsigns = false,
        dap = false,
        dap_ui = false,
        fidget = false,
        blink_cmp = true,
        leap = false,
        mini_clue = false,
        mini_indentscope = false,
        aerial = true,
      },
    },
  },
}
