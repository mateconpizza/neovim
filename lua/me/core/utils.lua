---@class me.core.utils
local M = {}

-- checks if a value exists in an array
---@param array string[]
---@param target any
---@return boolean
function M.contains(array, target)
  for _, value in ipairs(array) do
    if value == target then
      return true
    end
  end
  return false
end

-- converts string to boolean
---@param value string
---@return boolean
function M.boolme(value)
  local falseish = { 'false', 'no', 'n', '1', 1, false, nil, 'nil' }
  if M.contains(falseish, value) then
    return false
  end

  return true
end

-- get plugin from lazy
---@param name string
function M.get_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

-- checks if a plugin is installed
---@param plugin string
---@return boolean
function M.has_plugin(plugin)
  return M.get_plugin(plugin) ~= nil
end

---@generic T
---@param list T[]
---@return T[]
function M.deduplicate(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

-- wich command
---@param cmd string
---@return string|nil
M.which = function(cmd)
  local result = io.popen('which ' .. cmd, 'r')
  if not result then
    return nil
  end

  local path = result:read('*a')
  if path == '' then
    return nil
  end

  result:close()
  return path
end

-- check if file exists
---@return boolean
---@param f string
M.file_exist = function(f)
  local file = io.open(f, 'r')
  if not file then
    return false
  end

  return true
end

-- save table to json
---@param fname string
---@param t table
M.write_json = function(fname, t)
  local data = vim.fn.json_encode(t)
  if not data then
    Core.warnme('write: failed to encode data to JSON')
    return false
  end

  local success, err = pcall(vim.fn.writefile, { data }, fname)
  if not success then
    Core.warnme('write_json: ' .. err)
  end

  return success
end

-- trim string
function M.trimstr(str)
  return str:gsub('^%s*(.-)%s*$', '%1')
end

-- garbage collector log file
---@param path string
---@param size_kb number
function M.gc_logfile(path, size_kb)
  size_kb = size_kb or 500
  local logfile = io.open(path, 'r')
  if not logfile then
    return
  end

  local size_bytes = logfile:seek('end')
  logfile:close()

  local kilobytes = size_bytes / 1024

  if kilobytes > size_kb then
    Core.warnme(string.format('Log file size: %.2f KB exceeds limit of %d KB\nRemoving %s', kilobytes, size_kb, path))
    os.remove(path)
  end
end

---@param opts? { buf?: integer, width?: integer, height?: integer, lines?: string[], focus?: boolean }
---@return { buf: integer, win: integer }
M.create_floating_window = function(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.7)
  local height = opts.height or math.floor(vim.o.lines * 0.7)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf
  if type(opts.buf) == 'number' and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  if opts.lines then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, opts.lines)
  end

  if opts.focus ~= false then
    vim.api.nvim_set_current_win(win)
    vim.api.nvim_win_set_cursor(win, { 1, 0 })
  end

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

  return { buf = buf, win = win }
end

---@param winid integer
---@return boolean
function M.is_float(winid)
  return vim.api.nvim_win_get_config(winid).relative ~= ''
end

return M
