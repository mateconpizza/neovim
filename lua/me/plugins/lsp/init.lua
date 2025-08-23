-- lsp.config
return {
  { -- https://github.com/j-hui/fidget.nvim
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    -- https://github.com/j-hui/fidget.nvim/issues/288
    commit = '17ce5ac3b4e5ef590d4f4fd7d91e8fc233114074',
    opts = {
      notification = {
        window = { winblend = 0 },
      },
      progress = {
        display = {
          done_icon = '✓',
        },
      },
    },
    enabled = true,
  },

  { -- https://github.com/williamboman/mason.nvim
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    enabled = true,
    opts_extend = { 'ensure_installed' },
    opts = {
      ui = {
        icons = {
          package_installed = '',
          package_pending = '➜',
          package_uninstalled = '',
        },
      },
      ensure_installed = {
        'checkmake',
        'prettier',
        'stylua',
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  { -- https://github.com/b0o/SchemaStore.nvim
    'b0o/SchemaStore.nvim',
    enabled = false,
    lazy = false,
  },
}
