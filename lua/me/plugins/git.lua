-- git.lua
local Git = Core.git

return {
  { -- a git wrapper so awesome, it should be illegal
    'https://github.com/tpope/vim-fugitive',
    cmd = { 'Git', 'G', 'Gw' },
    keys = function()
      return {
        { '<leader>g', '', desc = '+git', mode = { 'n', 'v' } },
        { '<leader>go', '<CMD>tab Git<CR>', desc = 'git fugitive' },
        { '<leader>gf', Core.find_files, desc = 'git files' },
        { '<leader>ga', '', desc = '+actions' },
        { '<leader>gaa', Git.amend_noedit, desc = 'git amend noedit' },
        { '<leader>gap', Git.push, desc = 'git push' },
        { '<leader>gaA', Git.amend, desc = 'git amend' },
        { '<leader>gd', '', desc = '+diff' },
        {
          '<leader>gdc',
          function()
            vim.cmd('Gvdiffsplit!') -- go to next change '[c' ']c'
          end,
          desc = 'resolve conflict',
        },
        { '<leader>g2', '<CMD>diffget //2<CR>', desc = '//2 accept our changes' },
        { '<leader>g3', '<CMD>diffget //3<CR>', desc = '//3 accept their changes' },
        -- :0Glog - select one version, which opens up in a split. Then use gO to open another vertical split.
        -- Go back to quickfix, select the other version I want to diff it against.
        -- Navigate to the each buffer and do a :diffthis . Is there a better way?
        { '<leader>gdl', '<CMD>0Gclog<CR>', desc = 'show file versions' },
        {
          '<leader>gD',
          function()
            vim.cmd('only') -- close all other windows
            vim.cmd('diffoff!') -- turn off diff mode
            vim.cmd('Gdiffsplit') -- open a Git diff split
          end,
          mode = 'n',
          desc = 'Open Git diff split',
        },
      }
    end,
    enabled = true,
  },

  { -- git integration for buffers
    'https://github.com/lewis6991/gitsigns.nvim',
    event = 'InsertEnter',
    opts = {
      -- stylua: ignore start
      signs = {
        add           = { text = '+'  },
        change        = { text = '~'  },
        delete        = { text = '_'  },
        topdelete     = { text = '-'  },
        changedelete  = { text = '~_' },
        untracked     = { text = '┆'  },
      },
      signs_staged_enable = false,
      signcolumn = true,
      numhl = false,
      linehl = false,
    },
    keys = {
      { '<leader>gb', '<CMD>Gitsigns toggle_current_line_blame<CR>', desc = 'git toggle blame' },
      -- hunks
      { '<leader>gh', '', desc = '+hunks', mode = { 'n', 'v' } },
      { ']h', '<CMD>Gitsigns next_hunk<CR>', desc = 'git next hunk' },
      { '[h', '<CMD>Gitsigns prev_hunk<CR>', desc = 'git prev hunk' },
      { ']H', '<CMD>Gitsigns nav_hunk first<CR>', desc = 'git prev hunk' },
      { '[H', '<CMD>Gitsigns nav_hunk last<CR>', desc = 'git prev hunk' },
      { ']p', '<CMD>Gitsigns preview_hunk<CR>', desc = 'git preview hunk' },
      { '<leader>ghs', '<CMD>Gitsigns stage_hunk<CR>', desc = 'git stage hunk', mode = { 'n', 'v' } },
      { '<leader>ghr', '<CMD>Gitsigns reset_hunk<CR>', desc = 'git reset hunk', mode = { 'n', 'v' } },
      { '<leader>ghS', '<CMD>Gitsigns stage_buffer<CR>', desc = 'git stage buffer' },
      { '<leader>ghu', '<CMD>Gitsigns undo_stage_hunk<CR>', desc = 'git undo stage hunk' },
      { '<leader>ghR', '<CMD>Gitsigns reset_buffer<CR>', desc = 'git reset buffer' },
      { '<leader>ghp', '<CMD>Gitsigns preview_hunk<CR>', desc = 'git preview hunk' },
      { '<leader>ghd', '<CMD>Gitsigns diffthis<CR>', desc = 'git diff this hunk' },
      { '<leader>ghD', '<CMD>lua require"gitsigns".diffthis("~")<CR>', desc = 'git diff this ~' },
      { '<leader>ghq', '<CMD>Gitsign setqflist<CR>', desc = 'hunks quickfix' },
      -- visual
      { 'gh', '<CMD>Gitsigns stage_hunk<CR>', desc = 'git stage hunk', mode = { 'o', 'x' } },
      { 'gH', '<CMD>Gitsigns stage_buffer<CR>', desc = 'git stage buffer', mode = { 'o', 'x' } },
      { 'ih', ':<C-U>Gitsigns select_hunk<CR>', desc = 'git select hunk', mode = { 'o', 'x' } },
      -- toggle
      { '<leader>ghl', '<CMD>Gitsigns toggle_linehl<CR>', desc = 'git highlight line' },
      { '<leader>ghn', '<CMD>Gitsigns toggle_numhl<CR>', desc = 'git highlight numbers' },
      { '<leader>gtn', '<CMD>Gitsigns toggle_numhl<CR>', desc = 'git highlight numbers' },
    },
    dependencies = { -- https://github.com/nvim-treesitter/nvim-treesitter
      'nvim-treesitter/nvim-treesitter',
      opts = function()
        Core.treesitter.add({ 'diff', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'git_config' })
      end,
    },
    enabled = true,
  },

  --[[ { -- single tabpage interface for easily cycling through diffs for all modified files for any git rev
    'https://github.com/sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
    config = true,
    keys = {
      { '<leader>gd', '', desc = '+diff' },
      { '<leader>gdo', '<CMD>DiffviewOpen<CR>', desc = 'diffview open' },
      { '<leader>gdc', '<CMD>DiffviewClose<CR>', desc = 'diffview close' },
      { '<leader>gdf', '<CMD>DiffviewToggleFiles<CR>', desc = 'diffview files' },
      { '<leader>gdh', '<CMD>DiffviewFileHistory %<CR>', desc = 'diffview file history' },
    },
    enabled = false,
  }, ]]
}
