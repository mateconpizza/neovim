-- autocmd.lua

---@class me.config.autocmds
local M = {}

local augroup = Core.augroup
local autocmd = vim.api.nvim_create_autocmd

--- Setup highlight on yank autocmd
function M.setup_highlight_yank()
  autocmd('TextYankPost', {
    group = augroup('highlight_yank'),
    callback = function()
      (vim.hl or vim.highlight).on_yank()
    end,
    desc = 'highlight on yank',
  })
end

--- Setup easy close with Q for common plugin windows
function M.setup_easy_close()
  autocmd({ 'FileType' }, {
    group = augroup('easy_close_Q'),
    pattern = Core.defaults.exclude_filetypes,
    -- pattern = {
    --   'aerial',
    --   'dap-float',
    --   'fugitive',
    --   'git',
    --   'help',
    --   'checkhealth',
    --   'man',
    --   'neotest-output',
    --   'neotest-output-panel',
    --   'neotest-summary',
    --   'netrw',
    --   'qf',
    --   'startuptime',
    -- },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set('n', 'Q', '<CMD>close<CR>', { buffer = event.buf, silent = true })
    end,
    desc = "use 'Q' to quit from common plugins",
  })
end

--- Setup restore cursor position on buffer read
function M.setup_restore_cursor()
  autocmd('BufReadPost', {
    group = augroup('last_location'),
    callback = function()
      local ft = vim.bo.filetype
      if vim.tbl_contains(Core.defaults.exclude_filetypes, ft) then
        return
      end
      --
      -- if ft == 'gitcommit' then
      --   return
      -- end

      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
    desc = 'go to last loc when opening a buffer',
  })
end

--- Setup X11 resource reload on save
function M.setup_xresources_reload()
  autocmd({ 'BufWritePost' }, {
    group = augroup('Xresources'),
    pattern = { '*xdefaults', '*Xresources', '*xresources' },
    command = '!xrdb -load ~/.config/X11/xresources',
    desc = 'reload xresources after buffer write',
  })
end

--- Setup dunst config reload on save
function M.setup_dunst_reload()
  autocmd({ 'BufWritePost' }, {
    group = augroup('Dunstrc'),
    pattern = { 'dunstrc' },
    command = '!dunst-ts -r',
    desc = 'reload dunstrc after buffer write',
  })
end

--- Setup JSON conceallevel fix
function M.setup_json_conceal()
  autocmd({ 'FileType' }, {
    group = augroup('json_conceal'),
    pattern = { 'json', 'jsonc', 'json5' },
    callback = function()
      vim.opt_local.conceallevel = 0
    end,
    desc = 'fix conceallevel for json files',
  })
end

--- Setup wrap and spell for text files
function M.setup_text_files()
  autocmd('FileType', {
    group = augroup('wrap_spell'),
    pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end,
    desc = 'enable wrap and spell for text files',
  })
end

--- Setup automatic root directory change
function M.setup_auto_root()
  autocmd({ 'BufEnter' }, {
    group = augroup('auto_root'),
    callback = function()
      vim.fn.chdir(Core.get_root())
    end,
    desc = 'automatically change to project root',
  })
end

--- Setup Go template comment string
function M.setup_go_templates()
  autocmd('FileType', {
    group = augroup('go_templates'),
    pattern = { 'gotmpl', 'gohtml' },
    callback = function()
      vim.bo.commentstring = '{{/* %s */}}'
    end,
    desc = 'set comment string for Go templates',
  })
end

--- Setup LSP attach commands
function M.setup_lsp_attach()
  autocmd({ 'LspAttach' }, {
    group = augroup('lsp_attach'),
    callback = function()
      Core.commands.lsp_info()
      Core.commands.lsp_log()
    end,
    desc = 'Run LSP commands on attach',
  })
end

--- Setup fugitive X key disable
function M.setup_fugitive_disable_x()
  autocmd('FileType', {
    group = augroup('fugitive_doom'),
    pattern = '*fugitive*',
    callback = function(args)
      if not vim.b[args.buf].fugitive_x_disabled then
        Core.warnme('fugitive_X disabled')
        vim.keymap.set('n', 'X', '<Nop>', { buffer = args.buf, silent = true })
        vim.b[args.buf].fugitive_x_disabled = true
      end
    end,
    desc = 'disable X (discard changes) in fugitive buffers',
  })
end

function M.setup_bigfile()
  autocmd('BufReadPre', {
    group = augroup('bigfile'),
    callback = function(event)
      local bigfile = Core.defaults.bigfile
      if not bigfile.enabled then
        return
      end

      local bufnr = event.buf
      local size = vim.fn.getfsize(event.match)
      if size > bigfile.threshold then
        -- buffer settings
        vim.opt_local.syntax = ''
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ''
        vim.opt_local.statuscolumn = ''
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.foldcolumn = '0'
        vim.opt_local.winbar = ''

        -- buffer treesitter
        Core.warnme('treesitter disabled on file: ' .. event.file)
        vim.treesitter.stop(bufnr)
      end
    end,
    desc = 'disable features for big files',
  })
end

--- Initialize all autocmds
function M.setup()
  M.setup_highlight_yank()
  M.setup_easy_close()
  M.setup_restore_cursor()
  M.setup_xresources_reload()
  M.setup_dunst_reload()
  M.setup_json_conceal()
  M.setup_text_files()
  M.setup_auto_root()
  M.setup_go_templates()
  M.setup_lsp_attach()
  M.setup_fugitive_disable_x()
  M.setup_bigfile()
end

return M
