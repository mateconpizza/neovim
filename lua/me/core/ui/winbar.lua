-- tabline.lua
---@class me.core.ui.winbar
local M = {}

---@class WinBar.Diagnostic
---@field enabled? boolean: enable diagnostics
---@field mini? boolean: minimalist mode
---@field bug_icon? string: show bug icon
---@field show_detail? boolean: show detail

---@class WinBar.Icons
---@field modified? string
---@field readonly? string
---@field git_branch? string

---@class WinBar.Opts
---@field enabled? boolean
---@field file_icon? boolean: show file icon
---@field diagnostics? WinBar.Diagnostic: diagnostics
---@field lsp_status? boolean: enable lsp name
---@field icons? WinBar.Icons
---@field show_single_buffer? boolean: show with single buffer
---@field exclude_filetypes? string[]
---@field exclude_buftypes? string[]
---@field git_branch? boolean: show git branch
M.opts = {
  enabled = true,

  file_icon = true,
  show_single_buffer = true,

  exclude_filetypes = {
    'aerial',
    'dap-float',
    'fugitive',
    'oil',
    'Trouble',
    'lazy',
    'man',
  },
  exclude_buftypes = {
    'terminal',
    'quickfix',
    'help',
    'nofile',
    'nowrite',
  },

  icons = {
    modified = Core.icons.all().ui.MidCircle or '●',
    readonly = '',
    git_branch = '',
  },

  diagnostics = {
    enabled = false,
    bug_icon = Core.icons.dap.signs.breakpoint or '🐛',
    show_detail = true,
  },

  lsp_status = true,
  git_branch = true,
}

local cache = Core.ui.utils.cache

function M.is_special_buffer()
  local buftype = vim.bo.buftype
  local filetype = vim.bo.filetype

  -- Skip special buffer types
  for _, bt in ipairs(M.opts.exclude_buftypes) do
    if buftype == bt then
      return true
    end
  end

  -- Skip special filetypes
  for _, ft in ipairs(M.opts.exclude_filetypes) do
    if filetype == ft then
      return true
    end
  end

  return false
end

function M.render()
  if M.is_special_buffer() then
    return ''
  end

  if not M.opts.show_single_buffer then
    local visible_buffers = vim.tbl_filter(function(buf)
      -- Count visibles buffers only. Ignore floating windows (fzf-lua, Mason, etc)
      return vim.api.nvim_buf_is_loaded(buf)
        and vim.api.nvim_buf_get_name(buf) ~= ''
        and Core.ui.utils.is_visible_in_normal_win(buf)
    end, vim.api.nvim_list_bufs())

    if #visible_buffers < 2 then
      return ''
    end
  end

  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == '' then
    -- return '[No Name]'
    return ''
  end

  local filename = vim.fn.fnamemodify(bufname, ':t')
  if filename == '' then
    return ''
  end

  -- Build components
  local components = {}

  -- Git branch (left side)
  if M.opts.git_branch then
    local git_branch = Core.ui.utils.get_git_branch(M.opts.icons.git_branch)
    if git_branch ~= '' then
      table.insert(components, git_branch)
    end
  end

  -- Spacer to right-align the rest
  table.insert(components, '%=')

  -- LSP status
  if M.opts.lsp_status then
    local lsp_status = Core.ui.utils.get_lsp_status()
    if lsp_status ~= '' then
      table.insert(components, lsp_status)
      table.insert(components, ' ')
    end
  end

  -- Diagnostics
  if M.opts.diagnostics.enabled then
    local diagnostics
    if M.opts.diagnostics.mini then
      diagnostics = Core.ui.utils.get_diagnostics_mini()
    else
      diagnostics = Core.ui.utils.get_diagnostics()
    end
    if diagnostics ~= '' then
      -- Add bug_icon
      -- FIX: drop the `bug_icon`
      if M.opts.diagnostics.bug_icon then
        table.insert(components, '%#ErrorMsg#' .. M.opts.diagnostics.bug_icon .. '%*' .. ' ')
      end

      -- Diagnostics detail
      if M.opts.diagnostics.show_detail then
        table.insert(components, diagnostics)
        table.insert(components, ' ')
      end
    end
  end

  -- Modified indicator
  if vim.bo.modified then
    table.insert(components, '%#WarningMsg#' .. M.opts.icons.modified .. '%*')
    table.insert(components, ' ')
  end

  -- Readonly indicator
  if vim.bo.readonly then
    table.insert(components, '%#ErrorMsg#' .. M.opts.icons.readonly .. '%*')
    table.insert(components, ' ')
  end

  -- File icon
  if M.opts.file_icon then
    local file_icon = Core.ui.utils.get_file_icon(filename)
    if file_icon ~= '' then
      table.insert(components, file_icon)
      table.insert(components, ' ')
    end
  end

  -- File path handling for duplicates
  local all_buffers = vim.api.nvim_list_bufs()
  local duplicates = 0
  for _, buf in ipairs(all_buffers) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if vim.fn.fnamemodify(name, ':t') == filename then
        duplicates = duplicates + 1
      end
    end
  end

  if duplicates > 1 then
    -- Show more of the path for disambiguation
    local relative_path = Core.ui.utils.get_relative_path(bufname)
    table.insert(components, '%#WinBar#' .. relative_path .. '%*')
  else
    table.insert(components, '%#WinBar#' .. filename .. '%*')
  end

  table.insert(components, ' ')

  return table.concat(components)
end

local function setup_highlights()
  local function set_hl(name, val)
    vim.api.nvim_set_hl(0, name, val)
  end

  set_hl('WinBar', { bold = true, italic = true })
  set_hl('WinBarNC', { bold = false, italic = true })
end

-- Auto-refresh winbar on relevant events
local function setup_autocmds()
  local group = Core.augroup('WinBar')
  vim.api.nvim_create_autocmd({
    'BufEnter',
    'BufWritePost',
    'TextChanged',
    'TextChangedI',
    'DiagnosticChanged',
    'LspAttach',
    'LspDetach',
  }, {
    group = group,
    callback = function()
      -- Clear cache on relevant events
      cache.diagnostics = {}
      cache.git_branch = nil
      -- Force winbar refresh
      vim.cmd('redrawstatus')
    end,
  })
end

---@param opts? WinBar.Opts
function M.setup(opts)
  M.opts = vim.tbl_deep_extend('keep', opts or {}, M.opts)

  if not M.opts.enabled then
    return
  end

  setup_highlights()
  setup_autocmds()

  -- Set up winbar
  vim.o.winbar = '%{%v:lua.Core.ui.winbar.render()%}'
end

return M
