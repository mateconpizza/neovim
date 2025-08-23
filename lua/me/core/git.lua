---@class me.core.git
local M = {}

---@return boolean
function M.fugitive_buf()
  return vim.bo.ft == 'fugitive'
end

---@param question string
---@param cmd string
function M.confirm(question, cmd)
  if not M.fugitive_buf() then
    print('err: not in vim-fugitive buffer')
    return
  end

  if Core.confirm(question .. ' [y/n]: ', { 'Yes', 'y' }) then
    vim.cmd(cmd)
  end
end

function M.push()
  M.confirm('git: push changes?', 'Git push')
end

function M.amend_noedit()
  M.confirm('git: amend changes?', 'Git commit --amend --no-edit')
end

function M.amend()
  M.confirm('git: amend changes with edition?', 'Git commit --amend')
end

return M
