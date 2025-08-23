-- autocmd.lua
local augroup = Core.augroup
local autocmd = vim.api.nvim_create_autocmd
local fugitive_called = false

autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
  desc = 'highlight on yank',
})

autocmd({ 'FileType' }, {
  group = augroup('easy_close_Q'),
  pattern = {
    'aerial',
    'dap-float',
    'fugitive',
    'git',
    'help',
    'checkhealth',
    'man',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'netrw',
    'qf',
    'startuptime',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'Q', '<CMD>close<CR>', { buffer = event.buf, silent = true })
  end,
  desc = "use 'Q' to quit from common plugins",
})

autocmd('BufReadPost', {
  group = augroup('last_location'),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = 'go to last loc when opening a buffer',
})

autocmd({ 'BufWritePost' }, {
  group = augroup('Xresources'),
  pattern = { '*xdefaults', '*Xresources', '*xresources' },
  command = '!xrdb -load ~/.config/X11/xresources',
  desc = 'reload xresources after buffer write',
})

autocmd({ 'BufWritePost' }, {
  group = augroup('Dunstrc'),
  pattern = { 'dunstrc' },
  command = '!dunst-ts -r',
  desc = 'reload dunstrc after buffer write',
})

autocmd({ 'FileType' }, {
  group = augroup('json_conceal'),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
  desc = 'fix conceallevel for json files',
})

autocmd('FileType', {
  group = augroup('wrap_spell'),
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd({ 'BufEnter' }, {
  group = augroup('auto_root'),
  callback = function()
    vim.fn.chdir(Core.get_root())
  end,
})

autocmd('FileType', {
  pattern = { 'gotmpl', 'gohtml' },
  callback = function()
    vim.bo.commentstring = '{{/* %s */}}'
  end,
})

autocmd({ 'LspAttach' }, {
  group = augroup('lsp_attach'),
  callback = function()
    vim.api.nvim_create_user_command('LspInfo', function()
      vim.cmd('checkhealth vim.lsp')
    end, {})
    vim.api.nvim_create_user_command('LspLog', function()
      local logpath = Core.env.xdg_state_home() .. '/nvim/' .. 'lsp.log'
      vim.cmd('e ' .. logpath)
    end, {})
  end,
  desc = 'Run :checkhealth vim.lsp',
})

autocmd('FileType', {
  group = augroup('fugitiveDoom'),
  pattern = '*fugitive*',
  callback = function()
    if not fugitive_called then
      vim.print('fugitive_X disabled')
      vim.keymap.set('n', 'X', '<Nop>', { buffer = true, silent = true })
      fugitive_called = true
    end
  end,
  desc = 'disable X (discard changes) in fugitive buffers',
})
