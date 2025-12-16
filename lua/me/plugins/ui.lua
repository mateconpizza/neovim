return {

  { -- icon provider
    'https://github.com/nvim-mini/mini.icons',
    version = '*',
    opts = {
      default = {
        file = { glyph = '󰈤' },
      },
      extension = {
        ['gomarks'] = { glyph = Core.icons.lsp.kinds.Field, hl = 'MiniIconsGreen' },
        ['snip'] = { glyph = '', hl = 'MiniIconsPurple' },
        ['gohtml'] = { glyph = '', hl = 'MiniIconsPurple' },
      },
    },
  },

  { -- highlight uses of the word under the cursor
    'https://github.com/tzachar/local-highlight.nvim',
    keys = {
      { '<leader>bw', vim.cmd.LocalHighlightToggle, desc = 'toggle highlight word' },
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

  { -- the fastest neovim colorizer
    'https://github.com/NvChad/nvim-colorizer.lua',
    cmd = {
      'ColorizerAttachToBuffer',
      'ColorizerDetachFromBuffer',
      'ColorizerReloadAllBuffers',
      'ColorizerToggle',
    },
    keys = {
      { '<leader>bc', '<CMD>ColorizerToggle<CR>', desc = 'toggle colorizer' },
    },
    opts = {
      filetypes = { '*', '!lazy' },
      buftype = { '*', '!prompt', '!nofile', '!TelescopePrompt' },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = 'background', -- Set the display mode.
        virtualtext = '■',
      },
    },
    enabled = true,
  },

  -- { -- indent guides
  --   'https://github.com/lukas-reineke/indent-blankline.nvim',
  --   event = 'VeryLazy',
  --   enabled = false,
  --   opts = {
  --     indent = {
  --       char = icon_indent,
  --       tab_char = icon_indent,
  --     },
  --     scope = { enabled = false },
  --     exclude = {
  --       filetypes = Core.defaults.exclude_filetypes,
  --     },
  --   },
  --   main = 'ibl',
  -- },
  --
  -- { -- visualize and operate on indent scope
  --   'https://github.com/echasnovski/mini.indentscope',
  --   version = false, -- wait till new 0.7.0 release to put it back on semver
  --   enabled = false,
  --   event = 'VeryLazy',
  --   opts = {
  --     symbol = icon_indent,
  --     options = { try_as_border = true },
  --   },
  --   init = function()
  --     vim.api.nvim_create_autocmd('FileType', {
  --       pattern = Core.defaults.exclude_filetypes,
  --       callback = function()
  --         vim.b.miniindentscope_disable = true
  --       end,
  --     })
  --   end,
  -- },

  { -- show next key clues
    'https://github.com/echasnovski/mini.clue',
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
      show_single_buffer = true,
      icons = { modified = '●', readonly = '' },
      git = {
        branch = {
          -- icon = '',
          icon = '',
        },
        diff = { enabled = true },
      },
      lsp = {
        clients = { enabled = true, separator = '' },
        progress = { enabled = true },
        diagnostics = { enabled = true, style = 'standard' },
      },
      exclusions = { filetypes = { 'gomarks', 'help' }, buftypes = { 'somefile', 'help' } },
      extensions = {
        modes = {
          enabled = true,
          format = function(mode)
            if not mode then return '' end
            -- return ' ■'
            return ' ' .. mode:sub(1, 1):lower()
          end,
        },
        pomodoro = { enabled = false },
      },
      layout = {
        left = { 'modes', 'git_branch', 'git_diff' },
        center = { 'pomodoro' },
        right = {
          'lsp_progress',
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
        WinBarGitBranch = { link = 'Constant' },
        WinBarLspProgress = { link = 'RetroboxDimmer' },
      },
    },
  },
}
