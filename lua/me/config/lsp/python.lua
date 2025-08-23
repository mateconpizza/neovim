---@type LSPServer
return {
  parsers = { 'ninja', 'python', 'rst', 'toml', 'requirements' },
  tools = { 'debugpy', 'mypy' },
  dap = function()
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
}
