---@class me.core.lsp
local M = {}
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

---Registered LSP names
M.servers = {}

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@param opts LspCommand
function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }

  return vim.lsp.buf_request(0, 'workspace/executeCommand', params, opts.handler)
end

M.code_action = function()
  if not Core.utils.has_plugin('fzf-lua') then
    Core.warnme('fzf-lua not installed. https://github.com/ibhagwan/fzf-lua')
    return
  end

  return require('fzf-lua').lsp_code_actions({
    winopts = {
      relative = 'cursor',
      row = 1.01,
      col = 0,
      height = 0.3,
      width = 0.5,
      preview = { hidden = 'hidden' },
    },
  })
end

---@param on_attach function
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

function M.capabilities()
  local has_blink, blink = pcall(require, 'blink.cmp')
  return vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_blink and blink.get_lsp_capabilities() or {}
  )
end

---@param bufnr integer
function M.keymaps(bufnr)
  local map = Core.keymap_buf
  -- stylua: ignore start
  map(bufnr, 'gr', '', '+lsp', { 'n', 'v' })
  map(bufnr, 'grn', vim.lsp.buf.rename, 'lsp rename')
  map(bufnr, 'gra', M.code_action, 'code action', { 'n', 'v' })
  map(bufnr, 'grr', "<CMD>FzfLua lsp_references      jump1=true ignore_current_line=true<CR>", 'goto references')
  map(bufnr, 'gd',  "<CMD>FzfLua lsp_definitions     jump1=true ignore_current_line=true<CR>", 'goto definition')
  map(bufnr, 'gri', "<CMD>FzfLua lsp_implementations jump1=true ignore_current_line=true<CR>", 'goto implementation')
  map(bufnr, 'gy',  "<CMD>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<CR>", 'type definition')
  map(bufnr, 'gO',  "<CMD>FzfLua lsp_document_symbols<CR>", 'document symbols')
  map(bufnr, 'K',   vim.lsp.buf.hover, 'hover documentation')
  map(bufnr, '<C-s>', vim.lsp.buf.signature_help, 'signature documentation', 'i')
  -- lsp
  map(bufnr, '<leader>l', '', '+lsp', { 'n', 'v' })
  map(bufnr, '<leader>lc', vim.lsp.codelens.run, 'run codelens', { 'n', 'v' })
  map(bufnr, '<leader>lC', vim.lsp.codelens.refresh, 'refresh n display codelens')
  map(bufnr, '<leader>ld', "<CMD>FzfLua diagnostics_workspace<CR>", 'workspace symbols')
  map(bufnr, '<leader>lws', "<CMD>FzfLua lsp_workspace_symbols<CR>", 'workspace symbols')
  map(bufnr, '<leader>lwa', vim.lsp.buf.add_workspace_folder, 'workspace add folder')
  map(bufnr, '<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'workspace remove Folder')
  map(bufnr, '<leader>lwl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end, 'workspace list folders')
  -- stylua: ignore stop
end

function M.get_servers()
  return Core.utils.deduplicate(M.servers)
end

---Register one or more servers.
---@param names string|string[] A server name or a table of server names
---@return table # Returns the module table `M` for chaining
function M.register(names)
  -- Table
  if type(names) == 'table' then
    for _, name in ipairs(names) do
      table.insert(M.servers, name)
    end
  -- String
  elseif type(names) == 'string' then
    table.insert(M.servers, names)
  else
    error('M.enable expects a string or table of strings')
  end

  return M
end

---Enables all registered LSPs.
---@return nil
function M.start()
  for _, name in pairs(M.servers) do
    vim.lsp.enable(name)
  end
end

return M
