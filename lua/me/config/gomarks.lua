-- tags completion for `gomarks` buffers

local ok_utils, utils = pcall(require, 'coq_3p.utils')
if not ok_utils then return end

--- @class gomarksConf
--- @field database string
--- @field default string
--- @field cmd string
--- @field args fun(dbname: string): string

---@class cmp.gomarks
---@field cache table
---@field gomarks gomarksConf
local M = {
  cache = {
    items = nil,
  },
  gomarks = {
    database = '',
    default = 'bookmarks',
    cmd = 'gm',
    args = function(dbname)
      return 'gm -n ' .. dbname .. ' ' .. 'tags --json'
    end,
  },
}

local function extract_database_name(bufnr)
  if M.gomarks.database ~= '' then return M.gomarks.database end

  -- Get all lines from the buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Pattern to match database field with optional quotes
  local db_pattern = '^#%s*database:%s*["\']?([^"\'%s]+)["\']?'

  -- Search through lines for database field
  for _, line in ipairs(lines) do
    local db_name = line:match(db_pattern)
    if db_name then
      M.gomarks.database = db_name
      return db_name
    end
  end

  -- Return nil if no database field found
  return nil
end

---@return table<string, integer> tag_counter
local function get_tag_counter(database_name)
  local cached = M.cache[database_name]
  if cached then return cached end

  database_name = database_name or M.gomarks.default
  local cmd = M.gomarks.args(database_name)
  local handle = io.popen(cmd)
  if not handle then
    vim.notify('Failed to run gm', vim.log.levels.ERROR)
    return {}
  end

  local output = handle:read('*a')
  handle:close()

  local ok, decoded = pcall(vim.fn.json_decode, output)
  if not ok or type(decoded) ~= 'table' then
    vim.notify('gomarks-cmp: failed to decode gm JSON output', vim.log.levels.INFO)
    return { error = 1 }
  end

  M.cache[database_name] = decoded
  return decoded
end

function M.setup()
  COQsources = COQsources or {}
  COQsources[utils.new_uid(COQsources)] = {
    name = 'gmtags',
    ln = 'TAGS',
    fn = function(args, callback)
      --- @type lsp.CompletionItem[]
      local items = M.cache.items or {}
      if #items > 0 then
        callback({
          isIncomplete = true, -- false = cacheable, true = always reload
          items = items,
        })
        return
      end

      local filetypes = { 'gomarks' }
      if not vim.tbl_contains(filetypes, vim.bo.filetype) then
        callback(nil)
        return
      end

      local bufnr = vim.api.nvim_get_current_buf()
      local database_name = extract_database_name(bufnr)
      local tag_counter = get_tag_counter(database_name)

      local index = 0
      for tag, count in pairs(tag_counter) do
        index = index + 1

        --- @type lsp.CompletionItem
        local item = {
          label = string.format('%s (%d)', tag, count),
          insertText = tag .. ',',
          filterText = tag,
          kind = vim.lsp.protocol.CompletionItemKind.Field,
          detail = count .. ' items with tag "' .. tag .. '"',
          sortText = string.format('%04d', index),
          insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
        }
        table.insert(items, item)
      end

      M.cache.items = items

      callback({
        isIncomplete = true, -- false = cacheable, true = recargar siempre
        items = items,
      })
    end,
  }
end

return M
