local icon_indent = Core.icons.all().bar.b
local colors = Core.colors.current()

return {

  { -- https://github.com/nvim-tree/nvim-web-devicons
    'nvim-tree/nvim-web-devicons',
    enabled = true,
    opts = {
      override_by_extension = {
        ['gomarks'] = {
          icon = Core.icons.lsp.kinds.Field,
          color = colors.green,
          name = 'Bookmark',
        },
        ['gohtml'] = {
          icon = '',
          color = colors.red,
          name = 'GoHTML',
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
    config = function()
      local folded_hl = vim.api.nvim_get_hl(0, { name = 'Folded', link = false })
      vim.api.nvim_set_hl(0, 'MyLocalHighlight', {
        italic = true,
        bold = true,
        bg = folded_hl.bg,
      })
      require('local-highlight').setup({
        hlgroup = 'MyLocalHighlight',
        cw_hlgroup = nil,
        insert_mode = false,
        min_match_len = 1,
        max_match_len = math.huge,
        animate = { enabled = false },
      })
    end,
    enabled = true,
  },

  { -- my.statusline.nvim
    dir = '~/dev/lua/stat.nvim',
    cmd = 'Statusline',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>bl', '<CMD>Statusline<CR>', desc = 'toggle statusline' },
    },
    opts = {},
    lazy = true,
    enabled = Core.env.get('NVIM_THEME', '') ~= 'retrobox',
  },

  { -- https://github.com/NvChad/nvim-colorizer.lua
    'NvChad/nvim-colorizer.lua',
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
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = 'background', -- Set the display mode.
        virtualtext = '■',
      },
    },
    enabled = true,
  },

  { -- https://github.com/lukas-reineke/indent-blankline.nvim
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    enabled = true,
    opts = {
      indent = {
        char = icon_indent,
        tab_char = icon_indent,
        -- char = '│',
        -- tab_char = '│',
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          'alpha',
          'dashboard',
          'fzf',
          'help',
          'lazy',
          'lazyterm',
          'mason',
          'neo-tree',
          'notify',
          'oil_preview',
          'toggleterm',
          'trouble',
          'Trouble',
        },
      },
    },
    main = 'ibl',
  },

  { -- https://github.com/echasnovski/mini.indentscope
    'echasnovski/mini.indentscope',
    version = false, -- wait till new 0.7.0 release to put it back on semver
    enabled = true,
    event = 'VeryLazy',
    opts = {
      symbol = icon_indent,
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'alpha',
          'dashboard',
          'fzf',
          'help',
          'lazy',
          'lazyterm',
          'mason',
          'notify',
          'oil',
          'toggleterm',
          'trouble',
          'Trouble',
        },
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
}
