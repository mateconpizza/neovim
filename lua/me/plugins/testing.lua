-- me.plugins.testing

return {
  { -- https://github.com/nvim-neotest/neotest
    'nvim-neotest/neotest',
    enabled = Core.env.testing,
    commit = "3c81345c28cd639fcc02843ed3653be462f47024",
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
    },
    opts = {
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          vim.cmd('copen')
        end,
      },
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace('neotest')
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == 'number' then
            if type(config) == 'string' then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == 'table' and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter = adapter(config)
              else
                error('Adapter ' .. name .. ' does not support setup')
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require('neotest').setup(opts)
    end,
    keys = {
    -- stylua: ignore start
    { '<leader>t', '', desc = '+testing' },
    { '<leader>tt', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'test run file' },
    { '<leader>tT', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'test run all files' },
    { '<leader>tr', function() require('neotest').run.run() end, desc = 'test run nearest' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'test toggle summary' },
    { '<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = 'test show output' },
    { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'test toggle output panel' },
    { '<leader>tS', function() require('neotest').run.stop() end, desc = 'test stop' },
    { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'test run last' },
      -- stylua: ignore end
    },
  },

  { -- https://github.com/mfussenegger/nvim-dap
    'mfussenegger/nvim-dap',
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "test and debug nearest" },
    },
  },
}
