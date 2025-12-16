-- lsp.servers.basedpyright
return {
  { -- https://github.com/nvim-treesitter/nvim-treesitter
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    opts = function()
      Core.treesitter.add({ 'ninja', 'python', 'rst', 'toml', 'requirements' })
    end,
  },

  { -- https://github.com/williamboman/mason.nvim
    'williamboman/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then vim.list_extend(opts.ensure_installed, { 'debugpy', 'mypy' }) end
    end,
  },

  { -- https://github.com/mfussenegger/nvim-dap
    'mfussenegger/nvim-dap',
    optional = true,
    enabled = true,
    dependencies = {
      -- An extension for nvim-dap, providing default configurations for python
      -- and methods to debug individual test methods or classes.
      { 'https://codeberg.org/mfussenegger/nvim-dap-python', ft = 'python', enabled = true },
    },
    opts = function()
      local pypath = Core.env.xdg_data_home() .. '/nvim/mason/packages/debugpy/venv/bin/python'
      require('dap').configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          -- justMyCode = false,
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return vim.fn.exepath('python3') or vim.fn.exepath('python')
            end
          end,
        },
      }
      require('dap-python').setup(pypath)
    end,
  },

  { -- https://github.com/nvim-neotest/neotest
    'nvim-neotest/neotest',
    enabled = Core.env.testing,
    dependencies = { -- neotest adapter for python. supports pytest and unittest test files.
      { 'https://github.com/nvim-neotest/neotest-python', enabled = Core.env.testing, ft = 'python' },
    },
    opts = {
      adapters = {
        ['neotest-python'] = {},
      },
    },
  },
}
