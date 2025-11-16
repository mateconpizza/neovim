---@diagnostic disable: undefined-field

---@class Core
---@field colors me.core.colors
---@field env me.core.env
---@field fold me.core.fold
---@field git me.core.git
---@field icons me.core.icons
---@field lsp me.core.lsp
---@field lspp me.core.lspp
---@field misc me.core.misc
---@field retain me.core.retain
---@field toggle me.core.toggle
---@field treesitter me.core.treesitter
---@field utils me.core.utils
---@field manager me.core.manager
---@field defaults me.core.defaults
---@field commands me.core.commands
local M = {}

setmetatable(M, {
  __index = function(tbl, key)
    tbl[key] = require('me.core.' .. key)
    return tbl[key]
  end,
})

M.config = {}

---@alias Core.HighlightAttrs vim.api.keyset.highlight
---@type table<string, Core.HighlightAttrs>
M.hi = setmetatable({}, {
  __newindex = function(_, hlgroup, args)
    if args.link then
      vim.cmd(('hi! link %s %s'):format(hlgroup, args.link))
      return
    end

    local function set_hl(name, val)
      return vim.api.nvim_set_hl(0, name, val)
    end

    set_hl(hlgroup, args)
  end,
})

-- confirm
---@param mesg string
---@param choices string[]
function M.confirm(mesg, choices)
  local valid_choices = {}
  for _, choice in ipairs(choices) do
    valid_choices[choice:lower()] = true
  end

  ---@type string
  local choice = vim.fn.input({ prompt = mesg })
  choice = choice:lower()

  if not valid_choices[choice] then
    return false
  end

  return true
end

-- input from user
---@param mesg string
---@return string
function M.input(mesg)
  local choice = vim.fn.input({ prompt = mesg })
  choice = choice:lower()
  return choice
end

M.root_patterns = { '.git', '/lua' }
-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= '' and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- Find files using a finder
function M.find_files()
  if vim.uv.fs_stat(vim.uv.cwd() .. '/.git') then
    require('fzf-lua').git_files()
  else
    require('fzf-lua').files()
  end
end

function M.manpages()
  vim.cmd('FzfLua manpages previewer=man_native')
  -- FzfLua manpages previewer=man_native
  -- require('fzf-lua').manpages({ previewer = { 'man_native' } })
end

---@param name string
function M.augroup(name)
  return vim.api.nvim_create_augroup('me_' .. name, { clear = true })
end

--- checks if a given command is executable
---@param cmd string? command to check
---@return boolean
M.is_executable = function(cmd)
  return cmd and vim.fn.executable(cmd) == 1 or false
end

-- add keymap
---@param keys string
---@param func function|string
---@param desc string
---@param mode? string|string[]: defaults to 'n'
M.keymap = function(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { desc = desc })
end

-- keymap for buffer
---@param bufnr number
---@param keys string
---@param func function|string
---@param desc string
---@param mode? string|string[]: defaults to 'n'
M.keymap_buf = function(bufnr, keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
end

-- warn user
---@param s string
M.warnme = function(s)
  vim.api.nvim_echo({ { s, 'WarningMsg' } }, true, {})
end

-- error user
---@param s string
function M.errorme(s)
  vim.api.nvim_echo({ { s, 'ErrorMsg' } }, true, {})
end

-- notify user
---@param s string
M.notify = function(s)
  vim.notify(s)
end

-- set root
function M.set_root()
  vim.fn.chdir(Core.get_root())
end

return M
