local icons = Core.icons
local icon_indent = icons.all().bar.b
local colors = Core.colors.current()

return {

  { -- https://github.com/nvim-tree/nvim-web-devicons
    'nvim-tree/nvim-web-devicons',
    enabled = true,
    opts = {
      override_by_extension = {
        ['gomarks'] = {
          icon = Core.icons.lsp.kinds.Field,
          color = colors.normal.green,
          name = 'Bookmark',
        },
        ['gohtml'] = {
          icon = '',
          color = colors.normal.red,
          name = 'GoHTML',
        },
        ['snip'] = {
          icon = '',
          color = colors.bright.magenta,
          name = 'Snippet',
        },
      },
    },
    lazy = true,
  },

  { -- https://github.com/tzachar/local-highlight.nvim
    'tzachar/local-highlight.nvim',
    keys = {
      { '<leader>bw', '<CMD>LocalHighlightToggle<CR>', desc = 'toggle highlight word' },
    },
    opts = {
      hlgroup = 'CurrentWord',
      cw_hlgroup = nil,
      insert_mode = false,
      min_match_len = 1,
      max_match_len = math.huge,
      animate = { enabled = false },
    },
    enabled = true,
  },

  { -- https://github.com/nvim-mini/mini.hipatterns
    'nvim-mini/mini.hipatterns',
    version = '*',
    keys = {
      {
        '<leader>bc',
        function()
          require('mini.hipatterns').toggle(vim.api.nvim_get_current_buf())
        end,
        desc = 'toggle colorizer',
      },
    },
    config = function()
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          keymap_cmd = {
            pattern = '<CMD>',
            group = 'Special',
          },
          keymap_cr = {
            pattern = '<CR>',
            group = 'Special',
          },
          keymap_plug = {
            pattern = '<Plug>',
            group = 'Special',
          },

          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      })

      Core.hi.MiniHipatternsFixme = { link = 'TSDanger' }
      Core.hi.MiniHipatternsHack = { link = 'TSWarning' }
      Core.hi.MiniHipatternsTodo = { link = 'Todo' }
      Core.hi.MiniHipatternsNote = { link = 'TSNote' }
    end,
  },

  { -- https://github.com/lukas-reineke/indent-blankline.nvim
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    enabled = false,
    opts = {
      indent = {
        char = icon_indent,
        tab_char = icon_indent,
      },
      scope = { enabled = false },
      exclude = {
        filetypes = Core.defaults.exclude_filetypes,
      },
    },
    main = 'ibl',
  },

  { -- https://github.com/echasnovski/mini.indentscope
    'echasnovski/mini.indentscope',
    version = false, -- wait till new 0.7.0 release to put it back on semver
    enabled = false,
    event = 'VeryLazy',
    opts = {
      symbol = icon_indent,
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = Core.defaults.exclude_filetypes,
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  { -- https://github.com/echasnovski/mini.clue
    'echasnovski/mini.clue',
    version = false,
    lazy = false,
    enabled = true,
    config = function()
      local miniclue = require('mini.clue')
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },

          -- `[ ]` keys
          { mode = 'n', keys = ']' },
          { mode = 'x', keys = ']' },
          { mode = 'n', keys = '[' },
          { mode = 'x', keys = '[' },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),

          { mode = 'n', keys = '<Leader>b', desc = '+buffers' },
          { mode = 'n', keys = '<Leader>m', desc = '+misc' },
          { mode = 'n', keys = '<Leader>lw', desc = '+workspace' },
        },
      })
    end,
  },

  { -- https://github.com/mateconpizza/winbar.nvim
    'mateconpizza/winbar.nvim',
    event = { 'BufRead', 'BufNewFile' },
    enabled = true,
    ---@module 'winbar'
    ---@type winbar.config
    opts = {
      enabled = true,
      dev_mode = true,
      filename = {
        enabled = true,
        icon = true,
      },
      modes = {
        enabled = true,
        format = function(_)
          return ' ■' -- █ ▉ ▊ ▋▌▍
        end,
      },
      show_single_buffer = true,
      icons = { modified = '●', readonly = '' },
      lsp = { enabled = true, separator = '' },
      git = { branch = { icon = '' }, diff = { enabled = true } },
      diagnostics = { style = 'standard' }, -- or 'mini'
      pomodoro = { enabled = true },
      layout = {
        left = { 'modes', 'coso', 'git_branch', 'git_diff' },
        center = {},
        right = {
          'lsp_status',
          'lsp_diagnostics',
          'modified',
          'readonly',
          'fileicon',
          'filename',
        },
      },
      highlights = {
        WinBarModeNormal = { link = 'NonText' },
        WinBarModeVisual = { link = 'Special' },
      },
    },
  },
}
