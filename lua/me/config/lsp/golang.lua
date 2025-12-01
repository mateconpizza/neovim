-- config.lsp.golang
-- not implemented yet

local function load_env_file()
  local env = {}
  local cwd = vim.fn.getcwd()
  local env_file = cwd .. '/.env'

  if vim.fn.filereadable(env_file) == 0 then return env end

  -- confirm user
  local q = "Load envs variables from '" .. env_file .. "'? [Y/n]: "
  if not Core.confirm(q, { 'Yes', 'y', '' }) then return env end

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

local dap = function()
  local ok, dap = pcall(require, 'dap')
  if not ok then
    Core.warnme('golang-dap: nvim-dap not found')
    return
  end

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
      program = '.',
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
      program = '.',
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
end

---@type LSPServer
return {
  parsers = { 'go', 'gomod', 'gowork', 'gosum', 'gotmpl' },
  tools = { 'goimports-reviser', 'golangci-lint', 'staticcheck', 'gofumpt', 'golines' },
  dap = dap,
}
