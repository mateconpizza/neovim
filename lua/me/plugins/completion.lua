return { -- https://github.com/ms-jpq/coq_nvim
  'ms-jpq/coq_nvim',
  branch = 'coq',
  build = ':COQdeps',
  event = 'InsertEnter',
  enabled = true,
  keys = {
    --[[ { -- https://github.com/ms-jpq/coq_nvim/issues/464#issuecomment-1250233282
      '.',
      function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('.<C-x><C-u><C-e>', true, false, true), 'n', true)
      end,
      desc = 'trigger coq completion',
    }, ]]
  },
  init = function()
    vim.g.coq_settings = {
      auto_start = 'shut-up',
      display = {
        mark_applied_notify = false,
        icons = { mappings = Core.icons.lsp.kinds, mode = 'long' },
        ghost_text = { enabled = true },
        preview = {
          border = 'rounded',
          -- positions = { south = 1, north = 2, west = 3, east = 4 },
        },
        pum = {
          source_context = { '(', ')' },
          fast_close = false,
        },
      },
      completion = {
        always = true,
        skip_after = { '{', '}', '[', ']' },
        sticky_manual = false, -- trigger completion on every keystroke after manual completion until you leave insert mode.
      },
      keymap = {
        recommended = false,
        manual_complete = '<c-space>',
        pre_select = false,
        manual_complete_insertion_only = true,
        jump_to_mark = '<c-j>',
      },
      -- stylua: ignore
      clients = {
        lsp         = { short_name = 'LSP',   always_on_top = {}, },
        snippets    = { short_name = 'SNIP',  always_on_top = true, user_path = vim.fn.stdpath('config') .. '/snippets', },
        paths       = { short_name = 'PATH',  always_on_top = true, preview_lines = 3 },
        tree_sitter = { short_name = 'TS',    always_on_top = false, enabled = true },
        buffers     = { short_name = 'BUFF',  same_filetype = true },
        tags        = { short_name = 'TAGS',  enabled = false },
        tmux        = { short_name = 'TMUX',  enabled = true },
      },
    }

    local nmap = vim.api.nvim_set_keymap
    nmap('i', '<Esc>', [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]], { expr = true, silent = true })
    nmap('i', '<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true })
    nmap('i', '<BS>', [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true })
    nmap(
      'i',
      '<CR>',
      [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]],
      { expr = true, silent = true }
    )
  end,
  dependencies = { -- https://github.com/ms-jpq/coq.thirdparty
    -- { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
    { 'ms-jpq/coq.thirdparty', branch = '3p' },
  },
  config = function()
    if vim.bo.filetype == 'gomarks' then require('me.config.gomarks').setup() end

    -- stylua: ignore
    require('coq_3p')({
      { src = 'nvimlua',  short_name = 'API',   conf_only = true }, -- Lua
      { src = 'bc',       short_name = 'MATH',  precision = 6 }, -- calculator
      { src = 'cow',      short_name = 'COW',   trigger = '!cow' },
      { src = 'figlet',   short_name = 'BIG',   trigger = '!big',  fonts = { '/usr/share/figlet/standard.flf' } },
      -- { src = "vim_dadbod_completion", short_name = "DB" },
      -- { src = "dap" },
      {
        src = 'repl',
        sh = 'bash',
        shell = { p = 'perl', n = 'node' },
        max_lines = 99,
        deadline = 500,
        unsafe = { 'rm', 'poweroff', 'mv' },
      },
    })
  end,
}
