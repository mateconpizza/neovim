return {

  { -- https://github.com/echasnovski/mini.bufremove
    'echasnovski/mini.bufremove',
    -- stylua: ignore
    keys = {
      { '<leader>bd', '', desc = '+buffers' },
      { '<leader>bdc', function() require('mini.bufremove').delete(0, false) end, desc = 'buffer delete' },
      { '<leader>bdF', function() require('mini.bufremove').delete(0, true) end, desc = 'buffer delete (force)' },
    },
    enabled = true,
  },

  { -- https://github.com/toppair/peek.nvim
    -- dependencies: webkit2gtk (webview)
    -- BUG: https://github.com/toppair/peek.nvim/issues/79
    dir = '~/dev/git/lualang/peek.nvim',
    build = 'deno task --quiet build:fast',
    opts = {
      theme = vim.o.background,
      app = 'webview', -- webview
    },
    -- stylua: ignore
    keys = {
      { '<leader>mp', function() require('peek').open() end, desc = 'peek open' },
      { '<leader>mP', function () require('peek').close() end, desc = 'peek close' },
    },
    enabled = Core.is_executable('deno'),
  },

  { -- https://github.com/mbbill/undotree
    'mbbill/undotree',
    keys = { { '<leader>gu', '<CMD>UndotreeToggle<CR>', desc = 'undotree' } },
  },
}
