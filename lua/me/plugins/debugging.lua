local icons = Core.icons.dap

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input('Run with args: ', table.concat(args, ' ')) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], ' ')
  end
  return config
end

local function set_icons()
  local signs = {
    DapBreakpoint = { text = icons.signs.breakpoint, texthl = 'DiagnosticSignError' },
    DapBreakpointCondition = { text = icons.signs.breakpoint_condition, texthl = 'DiagnosticSignHint' },
    DapBreakpointRejected = { text = icons.signs.breakpoint_rejected, texthl = 'DiagnosticSignWarn' },
    DapLogPoint = { text = icons.signs.log_point, texthl = 'DiagnosticSignError' },
    DapStopped = { text = icons.signs.stopped, texthl = 'DiagnosticSignInfo', linehl = 'CursorLine' },
  }
  for sign, options in pairs(signs) do
    vim.fn.sign_define(sign, options)
  end
end

local dapui_config = {
  icons = icons.ui,
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { '<CR>', '<2-LeftMouse>' },
    open = 'o',
    remove = 'd',
    edit = 'e',
    repl = 'r',
    toggle = 't',
  },
  -- Use this to override mappings for specific elements
  element_mappings = {},
  expand_lines = true,
  layouts = {
    {
      elements = {
        'scopes',
        'breakpoints',
        'stacks',
        'watches',
      },
      size = 40,
      position = 'left',
    },
    {
      elements = { 'repl' },
      size = 4,
      position = 'bottom',
    },
  },
  controls = {
    enabled = true,
    -- Display controls in this element
    element = 'repl',
    icons = icons.controls,
  },
  floating = {
    max_height = 0.9,
    max_width = 0.5, -- Floats will be treated as percentage of your screen.
    border = 'rounded', -- vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
    mappings = {
      close = { 'q', '<Esc>' },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  },
}

return { -- debug adapter protocol client implementation
  'https://github.com/mfussenegger/nvim-dap',
  lazy = true,
  enabled = Core.env.debug,
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
  },
    -- stylua: ignore
    keys = {
      { '<leader>d', '', desc = '+debugging'},
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'breakpoint condition' },
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'toggle breakpoint' },
      { '<leader>da', function() require('dap').continue({ before = get_args }) end, desc = 'run with args' },
      { '<leader>dc', function() require('dap').continue() end, desc = 'continue' },
      { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'run to cursor' },
      { '<leader>dg', function() require('dap').goto_() end, desc = 'go to line (no execute)' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'step into' },
      { '<leader>dj', function() require('dap').down() end, desc = 'down' },
      { '<leader>dk', function() require('dap').up() end, desc = 'up' },
      { '<leader>dl', function() require('dap').run_last() end, desc = 'run Last' },
      { '<leader>do', function() require('dap').step_out() end, desc = 'step Out' },
      { '<leader>dO', function() require('dap').step_over() end, desc = 'step Over' },
      { '<leader>dP', function() require('dap').pause() end, desc = 'pause' },
      { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'toggle REPL' },
      { '<leader>ds', function() require('dap').session() end, desc = 'session' },
      { '<leader>dt', function() require('dap').terminate() end, desc = 'terminate' },
      { '<leader>dw', function() require('dap.ui.widgets').hover() end, desc = 'widgets' },
    },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    require('nvim-dap-virtual-text').setup({})
    set_icons()
    dapui.setup(dapui_config)
      -- stylua: ignore start
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
      Core.keymap('<leader>d?', function() dapui.eval(nil, { enter = true }) end, 'eval var under cursor')
    -- stylua: ignore end
  end,
}
