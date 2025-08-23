-- finders.lua

local default_fzf_profile = 'border-fused'

return {
  { -- https://github.com/ibhagwan/fzf-lua
    'ibhagwan/fzf-lua',
    lazy = true,
    enabled = true,
    cmd = { 'FzfLua' },
    config = function()
      require('fzf-lua').setup({
        Core.env.get('TMUX_FZF_PROFILE', default_fzf_profile),
        defaults = {
          file_icons = false,
          git_icons = false,
        },
        oldfiles = {
          include_current_session = true,
        },
        previewers = {
          builtin = {
            syntax_limit_b = 1024 * 100, -- 100KB
          },
        },
        fzf_opts = {
          -- https://github.com/ibhagwan/fzf-lua/issues/1929
          -- ['--layout'] = 'reverse-list',
          ['--pointer'] = '',
          ['--cycle'] = true,
        },
        keymap = {
          builtin = {
            -- neovim `:tmap` mappings for the fzf win
            -- true,        -- uncomment to inherit all the below in your custom config
            ['<M-Esc>'] = 'hide', -- hide fzf-lua, `:FzfLua resume` to continue
            ['<F1>'] = 'toggle-help',
            ['<F2>'] = 'toggle-fullscreen',
            -- Only valid with the 'builtin' previewer
            ['<F3>'] = 'toggle-preview-wrap',
            ['<F4>'] = 'toggle-preview',
            -- Rotate preview clockwise/counter-clockwise
            ['<F5>'] = 'toggle-preview-ccw',
            ['<F6>'] = 'toggle-preview-cw',
            -- `ts-ctx` binds require `nvim-treesitter-context`
            ['<F7>'] = 'toggle-preview-ts-ctx',
            ['<F8>'] = 'preview-ts-ctx-dec',
            ['<F9>'] = 'preview-ts-ctx-inc',
            ['<S-Left>'] = 'preview-reset',
            ['<C-d>'] = 'preview-page-down',
            ['<C-u>'] = 'preview-page-up',
            ['<M-S-down>'] = 'preview-down',
            ['<M-S-up>'] = 'preview-up',
          },
          fzf = {
            -- fzf '--bind=' options
            -- true,        -- uncomment to inherit all the below in your custom config
            ['ctrl-z'] = 'abort',
            ['ctrl-u'] = 'unix-line-discard',
            ['ctrl-f'] = 'half-page-down',
            ['ctrl-b'] = 'half-page-up',
            ['ctrl-a'] = 'beginning-of-line',
            ['ctrl-e'] = 'end-of-line',
            ['alt-a'] = 'toggle-all',
            ['alt-g'] = 'first',
            ['alt-G'] = 'last',
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ['f3'] = 'toggle-preview-wrap',
            ['f4'] = 'toggle-preview',
            ['shift-down'] = 'preview-page-down',
            ['shift-up'] = 'preview-page-up',
            -- use cltr-q to select all items and convert to quickfix list
            ['ctrl-q'] = 'select-all+accept',
          },
        },
      })

      vim.cmd('FzfLua register_ui_select')
    end,
    -- stylua: ignore start
    keys = {
      { '<leader>s', '', desc = '+search', mode = { 'n', 'v' } },
      -- search
      -- { '<C-p>', function() Core.find_files() end, desc = 'search files' },
      { '<C-p>', '<CMD>FzfLua files<CR>', desc = 'search files' },
      ---@diagnostic disable-next-line: undefined-field
      { '<leader>sf', function() require('fzf-lua').files({ cwd = vim.uv.cwd() }) end, desc = 'search all files' },
      { '<leader>?', '<CMD>FzfLua oldfiles<CR>', desc = '[?] find recently opened files' },
      { '<leader>:', '<CMD>FzfLua command_history<CR>', desc = 'search command history' },
      { '<leader>/', '<CMD>FzfLua grep_curbuf<CR>', desc = 'fuzzily search in current buf' },
      { '<leader>sr', '<CMD>FzfLua resume<CR>', desc = 'search resume' },
      { '<leader>sh', '<CMD>FzfLua helptags<CR>', desc = 'search help' },
      { '<leader>sg', '<CMD>FzfLua live_grep<CR>', desc = 'search by grep' },
      { '<leader>sw', '<CMD>FzfLua grep_cword<CR>', desc = 'search current word', mode = 'n' },
      { '<leader>sw', '<CMD>FzfLua grep_visual<CR>', desc = 'search current word', mode = 'v' },
      { '<leader>s?', function() require('fzf-lua').oldfiles({ cwd_only = true, stat_file = true}) end, desc = 'cwd history files', mode = 'n'},
      { '<leader><space>', function()
        require('fzf-lua').buffers({
          winopts = {
            relative = 'cursor',
            row = 1.00,
            col = 0,
            height = 0.4,
            width = 0.5,
            preview = { hidden = 'hidden' },
          },
        })
      end, desc = 'search buffers' },
      -- git search
      { '<leader>gs', '', desc = '+finders' },
      { '<leader>gss', '<CMD>FzfLua git_status<CR>', desc = 'git status' },
      { '<leader>gsx', '<CMD>FzfLua git_stash<CR>', desc = 'git stash' },
      { '<leader>gsB', '<CMD>FzfLua git_branches<CR>', desc = 'git branches' },
      { '<leader>gsb', '<CMD>FzfLua git_bcommits<CR>', desc = 'git buffer Commits' },
      -- misc
      -- stylua: ignore stop
      {
        mode = { 'i' },
        '<C-x><C-f>',
        function()
          require('fzf-lua').complete_file({
            cmd = 'rg --files',
            winopts = {
              relative = 'cursor',
              row = 1.00,
              col = 0,
              height = 0.3,
              width = 0.4,
              preview = { hidden = 'hidden' },
            },
          })
        end,
        desc = 'fuzzy complete file',
      },
    },
  },

  { -- https://github.com/haaag/projects.nvim
    dir = '~/dev/git/lualang/projects.nvim',
    dependencies = {
      'ibhagwan/fzf-lua',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      previewer = {
        enabled = true,
      },
      color = true,
      icons = {
        enabled = true,
      },
    },
    keys = {
      { '<leader>sp', '<CMD>FzfLuaProjects<CR>', desc = 'search projects' },
    },
    enabled = true,
  },

  { -- https://github.com/stevearc/oil.nvim
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      delete_to_trash = true,
    },
    cmd = { 'Oil' },
    keys = {
      { '-', '<CMD>Oil<CR>', desc = 'open parent directory' },
    },
    lazy = false,
    enabled = true,
  },

  { -- https://github.com/ggandor/flit.nvim
    'ggandor/flit.nvim',
    keys = function()
      local ret = {}
      for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
        ret[#ret + 1] = { key, mode = { 'n', 'x', 'o' }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = 'nx' },
    enabled = true,
  },

  { -- https://github.com/ggandor/leap.nvim
    'ggandor/leap.nvim',
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, desc = 'leap forward to' },
      { 'S', mode = { 'n', 'x', 'o' }, desc = 'leap backward to' },
      { 'gs', mode = { 'n', 'x', 'o' }, desc = 'leap from windows' },
    },
    config = function(_, opts)
      local leap = require('leap')
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ 'x', 'o' }, 'x')
      vim.keymap.del({ 'x', 'o' }, 'X')
    end,
    enabled = true,
  },
}
