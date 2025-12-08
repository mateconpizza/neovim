---@class me.core.lsp
local M = {
  _started = false,

  -- registered LSP names
  servers = {},
}

M.diagnostic = require('me.core.diagnostic')

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

-- execute an lsp command
---@param opts LspCommand
function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }

  return vim.lsp.buf_request(0, 'workspace/executeCommand', params, opts.handler)
end

-- show available code actions
M.code_action = function()
  if not Core.manager.has_plugin('fzf-lua') then
    Core.log.warning('[LSP code action] ', 'fzf-lua not installed. https://github.com/ibhagwan/fzf-lua')
    return
  end

  return require('fzf-lua').lsp_code_actions({
    winopts = {
      relative = 'cursor',
      row = 1.01,
      col = 0,
      height = 0.4,
      width = 0.5,
      ---@diagnostic disable-next-line: missing-fields
      preview = { hidden = false },
    },
  })
end

-- create an autocmd that calls the provided function when lsp attaches
---@param on_attach function function to execute when LSP attaches to a buffer
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

-- get LSP capabilities enhanced with completion engine capabilities
---@return table combined LSP capabilities
function M.capabilities()
  -- coq.nvim
  local has_coq, coq = pcall(require, 'coq')
  return vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_coq and coq.lsp_ensure_capabilities() or {}
  )
end

-- set up LSP keymaps for a buffer
---@param bufnr integer buffer number to set keymaps on
-- stylua: ignore
function M.keymaps(bufnr)
  local map = Core.keymap_buf
  map(bufnr, 'gr',  '', '+lsp', { 'n', 'v' })
  map(bufnr, 'grn', vim.lsp.buf.rename, 'lsp rename')
  map(bufnr, 'gra', M.code_action, 'code action', { 'n', 'v' })
  map(bufnr, 'grr', '<CMD>FzfLua lsp_references      jump1=true ignore_current_line=true<CR>', 'goto references')
  map(bufnr, "gd", function()
    require('fzf-lua').lsp_definitions({
      jump1 = true,
      ignore_current_line = true,
      workspace = true,
      ---@diagnostic disable-next-line: missing-fields
      winopts = { preview = { layout = 'vertical' }},
    })
  end, "goto definition")
  map(bufnr, 'gri', '<CMD>FzfLua lsp_implementations jump1=true ignore_current_line=true<CR>', 'goto implementation')
  map(bufnr, 'gy',  '<CMD>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<CR>', 'type definition')
  map(bufnr, 'gO',  '<CMD>FzfLua lsp_document_symbols<CR>', 'document symbols')
  map(bufnr, '<F2>', function()
    require('fzf-lua').lsp_document_symbols({
      prompt = "Symbols> ",
      symbols = { 'Function', 'Method' },
      ---@diagnostic disable-next-line: missing-fields
      winopts = { preview = { layout = "vertical" } },
    })
  end, 'document functions|methods')
  map(bufnr, 'K',   vim.lsp.buf.hover, 'hover documentation')
  map(bufnr, '<C-s>', vim.lsp.buf.signature_help, 'signature documentation', 'i')

  -- lsp
  map(bufnr, '<leader>l',   '', '+lsp', { 'n', 'v' })
  map(bufnr, '<leader>lc',  vim.lsp.codelens.run, 'run codelens', { 'n', 'v' })
  map(bufnr, '<leader>lC',  vim.lsp.codelens.refresh, 'refresh n display codelens')
  map(bufnr, '<leader>lws', '<CMD>FzfLua lsp_workspace_symbols<CR>', 'workspace symbols')
  map(bufnr, '<leader>lwa', vim.lsp.buf.add_workspace_folder, 'workspace add folder')
  map(bufnr, '<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'workspace remove Folder')
  map(bufnr, '<leader>lwl', function()
    vim.print(vim.lsp.buf.list_workspace_folders())
  end, 'workspace list folders')

  -- diagnostics
  map(bufnr, '<leader>ld', '', '+diagnostic', { 'n', 'v' })
  map(bufnr, '<leader>ldy', M.diagnostic.yank, 'copy diagnostic error')
  map(bufnr, '<leader>lds', M.diagnostic.show_buffer_diagnostics, 'quick fix diagnostic')
end

-- get deduplicated list of registered LSP servers
---@return table unique server names
function M.get_servers()
  return Core.utils.deduplicate(M.servers)
end

-- register one or more servers.
---@param names string|string[] A server name or a table of server names
---@return table # Returns the module table `M` for chaining
function M.register(names)
  -- table
  if type(names) == 'table' then
    for _, name in ipairs(names) do
      table.insert(M.servers, name)
    end
  -- string
  elseif type(names) == 'string' then
    table.insert(M.servers, names)
  else
    error('M.enable expects a string or table of strings')
  end

  return M
end

-- enables all registered lsps.
---@return nil
function M.start()
  if M._started then return Core.log.warning('[LSP] ', 'already started') end
  for _, name in pairs(M.servers) do
    vim.lsp.config(name, { capabilities = Core.lsp.capabilities() })
    vim.lsp.enable(name)
  end
  M._started = true
end

-- create user command to manually start all LSP servers
function M.usercmd_start()
  vim.api.nvim_create_user_command('LspStart', function()
    if not M._started then Core.log.debug('[LSP] ', 'starting...') end
    M.start()
  end, {})
end

-- create user command to show LSP health information
function M.usercmd_info()
  vim.api.nvim_create_user_command('LspInfo', function()
    vim.cmd('checkhealth vim.lsp')
  end, {})
end

-- create user command to open LSP log file
function M.usercmd_log()
  vim.api.nvim_create_user_command('LspLog', function()
    local logpath = Core.env.xdg_state_home() .. '/nvim/' .. 'lsp.log'
    vim.cmd('e ' .. logpath)
  end, {})
end

-- setup LSP keymaps and user commands
function M.setup()
  Core.keymap('<leader>ls', Core.lsp.start, 'start LSP')
  M.usercmd_log()
  M.usercmd_start()
end

return M
