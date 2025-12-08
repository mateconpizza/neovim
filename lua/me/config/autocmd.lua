-- autocmd.lua

---@class me.config.autocmds
local M = {}

local augroup = Core.augroup
local autocmd = vim.api.nvim_create_autocmd
local uv = vim.uv or vim.loop

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
      if vim.tbl_contains(Core.defaults.exclude_filetypes, ft) then return end

      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
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
    callback = function(args)
      local bufnr = args.buf

      if vim.bo[bufnr].buftype ~= '' then return end
      if vim.fn.filereadable(vim.api.nvim_buf_get_name(bufnr)) == 0 then return end

      local root = Core.get_root()
      ---@diagnostic disable-next-line: undefined-field
      if root and root ~= uv.cwd() then vim.fn.chdir(root) end
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
      Core.lsp.usercmd_info()
    end,
    desc = 'Run LSP commands on attach',
  })
end

function M.setup_bigfile()
  autocmd('BufReadPre', {
    group = augroup('bigfile'),
    callback = function(event)
      local bigfile = Core.defaults.bigfile
      if not bigfile.enabled then return end

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
        Core.log.warning('[autocmd] ', 'treesitter disabled on file: ' .. event.file)
        vim.treesitter.stop(bufnr)
      end
    end,
    desc = 'disable features for big files',
  })
end

function M.setup_leap_search_integration()
  vim.api.nvim_create_autocmd('CmdlineLeave', {
    group = vim.api.nvim_create_augroup('LeapOnSearch', {}),
    callback = function()
      local ev = vim.v.event
      local is_search_cmd = (ev.cmdtype == '/') or (ev.cmdtype == '?')
      local cnt = vim.fn.searchcount().total
      if is_search_cmd and not ev.abort and (cnt > 1) then
        -- Allow CmdLineLeave-related chores to be completed before
        -- invoking Leap.
        vim.schedule(function()
          -- We want "safe" labels, but no auto-jump (as the search
          -- command already does that), so just use `safe_labels`
          -- as `labels`, with n/N removed.
          local labels = require('leap').opts.safe_labels:gsub('[nN]', '')
          -- For `pattern` search, we never need to adjust conceallevel
          -- (no user input). We cannot merge `nil` from a table, but
          -- using the option's current value has the same effect.
          local vim_opts = { ['wo.conceallevel'] = vim.wo.conceallevel }
          require('leap').leap({
            pattern = vim.fn.getreg('/'), -- last search pattern
            windows = { vim.fn.win_getid() },
            opts = { safe_labels = '', labels = labels, vim_opts = vim_opts },
          })
        end)
      end
    end,
  })
end

--- Initialize all autocmds
function M.setup()
  M.setup_highlight_yank()
  M.setup_easy_close()
  M.setup_restore_cursor()
  M.setup_xresources_reload()
  M.setup_json_conceal()
  M.setup_text_files()
  M.setup_auto_root()
  M.setup_go_templates()
  M.setup_lsp_attach()
  M.setup_bigfile()
  M.setup_leap_search_integration()
end

return M
