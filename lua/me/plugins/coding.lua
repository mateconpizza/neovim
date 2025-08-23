local neocodeium_enabled = false

return {

  { -- https://github.com/stevearc/aerial.nvim
    'stevearc/aerial.nvim',
    opts = { show_guides = true },
    keys = {
      { '<F2>', '<CMD>AerialToggle<CR>', desc = 'aerial toggle' },
      { '[f', '<CMD>AerialPrev<CR>', desc = 'aerial prev' },
      { ']f', '<CMD>AerialNext<CR>', desc = 'aerial next' },
    },
  },

  { -- https://github.com/monkoose/neocodeium
    'monkoose/neocodeium',
    cmd = 'NeoCodeium',
    enabled = true,
    keys = {
      {
        '<leader>lS',
        function()
          neocodeium_enabled = not neocodeium_enabled
          vim.cmd('NeoCodeium toggle')
          Core.warnme(neocodeium_enabled and 'neocodeium enabled' or 'neocodeium disabled')
        end,
        desc = 'neocodeium toggle',
      },
    },
    config = function()
      local map = Core.keymap
      local nc = require('neocodeium')
      nc.setup({ enabled = false })

      map('<C-g>', nc.accept, 'neocodeium accept', 'i')
      map('<M-;>', nc.cycle_or_complete, 'neocodeium cycle', 'i')
    end,
  },

  { -- https://github.com/folke/lazydev.nvim
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    cmd = 'LazyDev',
    enabled = true,
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'Core', words = { 'Core' } },
      },
    },
  },
}
