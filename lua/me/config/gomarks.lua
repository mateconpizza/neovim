local gomarks_database = ''

local function extract_database_name(bufnr)
  if gomarks_database ~= '' then
    return gomarks_database
  end

  -- Get all lines from the buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Pattern to match database field with optional quotes
  local db_pattern = '^#%s*database:%s*["\']?([^"\'%s]+)["\']?'

  -- Search through lines for database field
  for _, line in ipairs(lines) do
    local db_name = line:match(db_pattern)
    if db_name then
      gomarks_database = db_name
      return db_name
    end
  end

  -- Return nil if no database field found
  return nil
end

---@return table<string, integer> tag_counter
local function get_tag_counter(database_name)
  database_name = database_name or 'bookmarks'
  local cmd = 'gm ' .. '-n ' .. database_name .. ' rec tags --json'
  local handle = io.popen(cmd)
  if not handle then
    vim.notify('Failed to run gm', vim.log.levels.ERROR)
    return {}
  end

  local output = handle:read('*a')
  handle:close()

  local ok, decoded = pcall(vim.fn.json_decode, output)
  if not ok or type(decoded) ~= 'table' then
    vim.notify('Failed to decode gm JSON output', vim.log.levels.ERROR)
    return {}
  end

  return decoded
end

--- @module 'blink.cmp'
--- @class blink.cmp.Source
local source = {}

-- `opts` table comes from `sources.providers.your_provider.opts`
-- You may also accept a second argument `config`, to get the full
-- `sources.providers.your_provider` table
function source.new(opts)
  vim.validate('gomarks.opts.count', opts.count, { 'boolean' })

  local self = setmetatable({}, { __index = source })
  self.opts = opts
  return self
end

function source:enabled()
  return vim.bo.filetype == 'gomarks'
end

-- (Optional) Non-alphanumeric characters that trigger the source
function source:get_trigger_characters()
  return { ',' }
end

function source:get_completions(ctx, callback)
  -- ctx (context) contains the current keyword, cursor position, bufnr, etc.
  -- You should never filter items based on the keyword, since blink.cmp will
  -- do this for you
  local bufnr = ctx.bufnr
  local row = ctx.cursor[1] -- 1-indexed
  local col = ctx.cursor[2] -- 1-indexed
  local start_col = ctx.bounds.start_col - 1
  local end_col = col

  local database_name = extract_database_name(bufnr)
  local tag_counter = get_tag_counter(database_name)
  --- @type lsp.CompletionItem[]
  local items = {}
  local index = 0
  for tag, count in pairs(tag_counter) do
    index = index + 1
    local text = tag .. ','

    --- @type lsp.CompletionItem
    local item = {
      -- label = tag,
      label = string.format('%s (%d)', tag, count),
      kind = require('blink.cmp.types').CompletionItemKind.Unit,
      filterText = tag,
      sortText = string.format('%04d', index),
      textEdit = {
        newText = text,
        range = {
          start = {
            line = row - 1,
            character = start_col,
          },
          ['end'] = {
            line = row - 1,
            character = end_col,
          },
        },
      },
      insertText = tag,
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
    }
    table.insert(items, item)
  end
  -- The callback *MUST* be called at least once. The first time it's called,
  -- blink.cmp will show the results in the completion menu. Subsequent calls
  -- will append the results to the menu to support streaming results.
  callback({
    items = items,
    -- Whether blink.cmp should request items when deleting characters
    -- from the keyword (i.e. "foo|" -> "fo|")
    -- Note that any non-alphanumeric characters will always request
    -- new items (excluding `-` and `_`)
    is_incomplete_backward = false,
    -- Whether blink.cmp should request items when adding characters
    -- to the keyword (i.e. "fo|" -> "foo|")
    -- Note that any non-alphanumeric characters will always request
    -- new items (excluding `-` and `_`)
    is_incomplete_forward = false,
  })
  -- (Optional) Return a function which cancels the request
  -- If you have long running requests, it's essential you support cancellation
  return function() end
end

-- (Optional) Before accepting the item or showing documentation, blink.cmp will call this function
-- so you may avoid calculating expensive fields (i.e. documentation) for only when they're actually needed
function source:resolve(item, callback)
  item = vim.deepcopy(item)

  -- Shown in the documentation window (<C-space> when menu open by default)
  -- item.documentation = {
  --   kind = 'markdown',
  --   value = '# Gomarks\n\ntag from [gomarks](https://github.com/haaag/gm)',
  -- }

  callback(item)
end

-- Called immediately after applying the item's textEdit/insertText
function source:execute(ctx, item, callback, default_implementation)
  -- By default, your source must handle the execution of the item itself,
  -- but you may use the default implementation at any time
  default_implementation()

  -- The callback _MUST_ be called once
  callback()
end

return source
