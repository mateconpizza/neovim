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

---Gets diagnostic counts for the current buffer
---@param bufnr number
---@return table # Table with counts {errors, warnings, info, hints}
local function get_diagnostic_counts(bufnr)
  local diag = vim.diagnostic
  return {
    errors = #diag.get(bufnr, { severity = diag.severity.ERROR }),
    warnings = #diag.get(bufnr, { severity = diag.severity.WARN }),
    hints = #diag.get(bufnr, { severity = diag.severity.HINT }),
    info = #diag.get(bufnr, { severity = diag.severity.INFO }),
  }
end

---Formats diagnostic counts in standard mode
---@param counts table
---@return string
local function format_standard(counts)
  local components = {}

  if counts.errors > 0 then
    table.insert(components, '%#DiagnosticError#E:' .. counts.errors .. '%*')
  end
  if counts.warnings > 0 then
    table.insert(components, '%#DiagnosticWarn#W:' .. counts.warnings .. '%*')
  end
  if counts.info > 0 then
    table.insert(components, '%#DiagnosticInfo#I:' .. counts.info .. '%*')
  end
  if counts.hints > 0 then
    table.insert(components, '%#DiagnosticHint#H:' .. counts.hints .. '%*')
  end

  return table.concat(components, ' ')
end

---Formats diagnostic counts in minimalist mode
---@param counts table
---@return string
local function format_mini(counts)
  local icon = Core.icons.dap.signs.breakpoint
  local components = {}

  if counts.errors > 0 then
    table.insert(components, '%#DiagnosticError#' .. icon .. ' ' .. counts.errors .. '%*')
  end
  if counts.warnings > 0 then
    table.insert(components, '%#DiagnosticWarn#' .. icon .. ' ' .. counts.warnings .. '%*')
  end
  if counts.info > 0 then
    table.insert(components, '%#DiagnosticInfo#' .. icon .. ' ' .. counts.info .. '%*')
  end
  if counts.hints > 0 then
    table.insert(components, '%#DiagnosticHint#' .. icon .. ' ' .. counts.hints .. '%*')
  end

  return table.concat(components, ' ')
end

---Gets a formatted string of diagnostic counts for the current buffer.
---This function caches the results for 100ms to prevent excessive updates.
---@return string # A string with the counts of errors, warnings, info, and hints
function M.get_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local current_time = vim.loop.hrtime()

  -- Cache diagnostics for 100ms to avoid excessive calls
  if M.cache.diagnostics[bufnr] and (current_time - M.cache.last_update) < 100000000 then
    return M.cache.diagnostics[bufnr]
  end

  local counts = get_diagnostic_counts(bufnr)
  local result = format_standard(counts)

  M.cache.diagnostics[bufnr] = result
  M.cache.last_update = current_time
  return result
end

---Gets a formatted string of diagnostic counts in minimalist mode for the current buffer.
---This function caches the results for 100ms to prevent excessive updates.
---@return string # A string with the counts using icons instead of prefixes
function M.get_diagnostics_mini()
  local bufnr = vim.api.nvim_get_current_buf()
  local current_time = vim.loop.hrtime()

  -- Use separate cache key for mini mode
  local cache_key = bufnr .. '_mini'
  if M.cache.diagnostics[cache_key] and (current_time - M.cache.last_update) < 100000000 then
    return M.cache.diagnostics[cache_key]
  end

  local counts = get_diagnostic_counts(bufnr)
  local result = format_mini(counts)

  M.cache.diagnostics[cache_key] = result
  M.cache.last_update = current_time
  return result
end

---Check if a buffer is visible in any non-floating window.
---@param bufnr integer Buffer handle
---@return boolean # true if visible in at least one normal window, false otherwise
function M.is_visible_in_normal_win(bufnr)
  return vim.iter(vim.fn.win_findbuf(bufnr)):any(function(win)
    return not Core.utils.is_float(win)
  end)
end

---Gets a formatted string of diagnostic counts for the current buffer.
---This function caches the results for 100ms to prevent excessive updates.
---@return string # A string with the counts of errors, warnings, info, and hints,
function M.get_diagnosticsOld()
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
