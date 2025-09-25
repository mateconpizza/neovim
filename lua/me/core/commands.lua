-- commands.lua

local user_command = vim.api.nvim_create_user_command

---@class me.core.commands
local M = {}

function M.grep()
  user_command('Grep', function(opts)
    vim.cmd('silent grep! ' .. opts.args)

    local qf_size = vim.fn.getqflist({ size = 0 }).size
    if qf_size == 0 then
      vim.notify("no results: '" .. opts.args .. "'", vim.log.levels.INFO)
      return
    end

    -- Open quickfix if results
    vim.cmd('copen')
    vim.cmd('wincmd p') -- Go back to the previous window
  end, {
    nargs = '+', -- requires at least one argument
    complete = 'file', -- file names autocmp
    desc = 'match patterns',
  })
end

function M.lsp_info()
  user_command('LspInfo', function()
    vim.cmd('checkhealth vim.lsp')
  end, {})
end

function M.lsp_log()
  user_command('LspLog', function()
    local logpath = Core.env.xdg_state_home() .. '/nvim/' .. 'lsp.log'
    vim.cmd('e ' .. logpath)
  end, {})
end

function M.setup()
  M.grep()
end

return M
