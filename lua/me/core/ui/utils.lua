-- utils.lua
---@class me.core.ui.utils
local M = {}

-- Cache for performance
M.cache = {
  diagnostics = {},
  git_branch = nil,
  last_update = 0,
}

function M.get_relative_path(bufname)
  -- local git_root = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
  -- local base_path = (git_root ~= '' and vim.fn.isdirectory(git_root) == 1) and git_root or vim.fn.getcwd()

  local relative_path = vim.fn.fnamemodify(bufname, ':~:.')
  if relative_path:sub(1, 1) == '~' then
    relative_path = vim.fn.fnamemodify(bufname, ':t')
  end

  return relative_path
end

function M.get_file_icon(filename)
  local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
  if has_devicons then
    local icon, hl = devicons.get_icon(filename, vim.fn.fnamemodify(filename, ':e'), { default = true })
    if icon and hl then
      return '%#' .. hl .. '#' .. icon .. '%*'
    end
  end
  return ''
end

function M.get_lsp_status()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ''
  end

  local names = {}
  for _, client in pairs(clients) do
    table.insert(names, client.name)
  end

  return '%#Comment#[' .. table.concat(names, ',') .. ']%*'
end

function M.get_git_branch(icon)
  if M.cache.git_branch then
    return M.cache.git_branch
  end

  -- Try to get git branch using vim.fn.system
  local handle = io.popen('git rev-parse --abbrev-ref HEAD 2>/dev/null')
  if handle then
    local branch = handle:read('*a'):gsub('\n', '')
    handle:close()
    if branch and branch ~= '' then
      M.cache.git_branch = '%#Comment#' .. icon .. ' ' .. branch .. '%*'
      return M.cache.git_branch
    end
  end

  M.cache.git_branch = ''
  return ''
end

function M.get_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local current_time = vim.loop.hrtime()

  -- Cache diagnostics for 100ms to avoid excessive calls
  if M.cache.diagnostics[bufnr] and (current_time - M.cache.last_update) < 100000000 then
    return M.cache.diagnostics[bufnr]
  end

  local diag = vim.diagnostic
  local errors = #diag.get(bufnr, { severity = diag.severity.ERROR })
  local warnings = #diag.get(bufnr, { severity = diag.severity.WARN })
  local hints = #diag.get(bufnr, { severity = diag.severity.HINT })
  local info = #diag.get(bufnr, { severity = diag.severity.INFO })

  local components = {}
  if errors > 0 then
    table.insert(components, '%#DiagnosticError#E:' .. errors .. '%*')
  end
  if warnings > 0 then
    table.insert(components, '%#DiagnosticWarn#W:' .. warnings .. '%*')
  end
  if info > 0 then
    table.insert(components, '%#DiagnosticInfo#I:' .. info .. '%*')
  end
  if hints > 0 then
    table.insert(components, '%#DiagnosticHint#H:' .. hints .. '%*')
  end

  local result = table.concat(components, ' ')
  M.cache.diagnostics[bufnr] = result
  M.cache.last_update = current_time

  return result
end

return M
