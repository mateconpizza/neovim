-- lsp.servers.go

local function load_env_file()
  local env = {}
  local cwd = vim.fn.getcwd()
  local env_file = cwd .. '/.env'

  if vim.fn.filereadable(env_file) == 0 then
    return env
  end

  -- confirm user
  local q = "Load envs variables from '" .. env_file .. "'? [Y/n]: "
  if not Core.confirm(q, { 'Yes', 'y', '' }) then
    return env
  end

  for line in io.lines(env_file) do
    local key, val = line:match('^%s*([%w_]+)%s*=%s*(.*)%s*$')
    if key and val then
      -- Remove possible surrounding quotes
      val = val:gsub([["]], ''):gsub([[]], '')
      env[key] = val
    end
  end

  Core.warnme("Loaded envs variables from '" .. env_file .. "'")
  vim.print(env)

  return env
end

return {
  { -- https://github.com/nvim-treesitter/nvim-treesitter
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    opts = function()
      Core.treesitter.add({ 'go', 'gomod', 'gowork', 'gosum', 'gotmpl' })
    end,
  },

  { -- https://github.com/williamboman/mason.nvim
    'williamboman/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(
          opts.ensure_installed,
          { 'goimports-reviser', 'golangci-lint', 'staticcheck', 'gofumpt', 'golines', 'delve' }
        )
      end
    end,
  },

  { -- https://github.com/mfussenegger/nvim-dap
    'mfussenegger/nvim-dap',
    optional = true,
    enabled = Core.env.debug,
    dependencies = {
      { 'leoluz/nvim-dap-go', opts = {}, enabled = Core.env.debug },
    },
    opts = function()
      local dap = require('dap')
      dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'dlv',
          args = { 'dap', '-l', '127.0.0.1:${port}' },
        },
      }
      dap.configurations.go = {
        {
          name = 'Debug',
          type = 'delve',
          request = 'launch',
          program = '${relativeFileDirname}',
        },
        {
          name = 'Debug file',
          type = 'delve',
          request = 'launch',
          program = '${file}',
        },
        {
          name = 'Debug with env',
          type = 'delve',
          request = 'launch',
          program = '${file}',
          env = load_env_file,
        },
        { -- configuration for debugging test files
          name = 'Debug test',
          type = 'delve',
          request = 'launch',
          mode = 'test',
          program = '${file}',
        },
        { -- works with go.mod packages and sub packages
          name = 'Debug test (go.mod)',
          type = 'delve',
          request = 'launch',
          mode = 'test',
          program = './${relativeFileDirname}',
        },
      }
    end,
  },

  { -- https://github.com/nvim-neotest/neotest
    'nvim-neotest/neotest',
    dependencies = {
      {
        'fredrikaverpil/neotest-golang', -- https://github.com/fredrikaverpil/neotest-golang
        version = '*',
        enabled = Core.env.testing,
        build = function()
          vim.cmd([[:TSUpdate go]])
        end,
      },
    },
    opts = {
      adapters = {
        ['neotest-golang'] = {
          go_test_args = { '-v', '-race', '-count=1', '-timeout=60s' },
          runner = 'gotestsum',
          dap_go_enabled = true,
        },
      },
    },
  },
}
